import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_review_eligibility_model.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_review_model.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_reviews_data_model.dart';
import 'package:evetick/features/reviews/data/models/review_summary_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Reviews of an organizer live in `users/{organizerId}/reviews/{reviewerId}`
/// (one per user). Like the event reviews, the rating summary is counted with
/// Firestore count queries and nothing is stored on the organizer's document,
/// so nobody can fake it from the app.
class OrganizerReviewsRepository {
  static const int pageSize = 10;
  static const int minTextLength = 10;
  static const int maxTextLength = 1000;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _reviews(String organizerId) =>
      firestore.collection('users').doc(organizerId).collection('reviews');

  // ---------------------------------------------------------------- read

  /// First page + rating summary + whether the user may write a review.
  Future<Result<OrganizerReviewsData>> getReviews({
    required String organizerId,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to see reviews'));
      }

      // Started together, awaited one by one.
      final summaryFuture = _loadSummary(organizerId);
      final pageFuture = _loadPage(
        organizerId: organizerId,
        cursor: null,
        userId: user.uid,
      );
      final eligibilityFuture = _eligibility(organizerId, user.uid);

      final summary = await summaryFuture;
      final page = await pageFuture;
      final eligibility = await eligibilityFuture;

      return Result.success(
        OrganizerReviewsData(
          summary: summary,
          reviews: page.reviews,
          hasMore: page.hasMore,
          cursor: page.cursor,
          eligibility: eligibility,
        ),
      );
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  /// "Load More Reviews": the page that starts after [cursor].
  Future<Result<OrganizerReviewsPage>> getMoreReviews({
    required String organizerId,
    required Object? cursor,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to see reviews'));
      }
      final page = await _loadPage(
        organizerId: organizerId,
        cursor: cursor,
        userId: user.uid,
      );
      return Result.success(page);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<ReviewSummary> _loadSummary(String organizerId) async {
    final counts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    await Future.wait([
      for (var star = 1; star <= 5; star++)
        _reviews(organizerId)
            .where('rating', isEqualTo: star)
            .count()
            .get()
            .then((snapshot) => counts[star] = snapshot.count ?? 0),
    ]);
    return ReviewSummary(counts: counts);
  }

  Future<OrganizerReviewsPage> _loadPage({
    required String organizerId,
    required Object? cursor,
    required String userId,
  }) async {
    Query<Map<String, dynamic>> query = _reviews(organizerId)
        .orderBy('createdAt', descending: true)
        .limit(pageSize);
    if (cursor is DocumentSnapshot<Map<String, dynamic>>) {
      query = query.startAfterDocument(cursor);
    }

    final snapshot = await query.get();

    final reviews = <OrganizerReview>[];
    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        reviews.add(
          OrganizerReview.fromJson(
            {
              ...data,
              'reviewId': doc.id,
              'createdAt': (data['createdAt'] as Timestamp?)?.toDate(),
            },
            currentUserId: userId,
          ),
        );
      } catch (_) {
        // A malformed review must not break the whole list.
      }
    }

    return OrganizerReviewsPage(
      reviews: reviews,
      hasMore: snapshot.docs.length == pageSize,
      cursor: snapshot.docs.isEmpty ? cursor : snapshot.docs.last,
    );
  }

  /// One review per user, never for yourself, and only for users who have a
  /// confirmed order on one of this organizer's events.
  Future<OrganizerReviewEligibility> _eligibility(
    String organizerId,
    String uid,
  ) async {
    if (uid == organizerId) return OrganizerReviewEligibility.isOrganizer;

    final existing = await _reviews(organizerId).doc(uid).get();
    if (existing.exists) return OrganizerReviewEligibility.alreadyReviewed;

    // Events the user has a confirmed order for.
    final orders = await firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .get();
    final attendedEventIds = <String>{};
    for (final doc in orders.docs) {
      final data = doc.data();
      if (data['status'] != 'confirmed') continue;
      final eventId = data['eventId']?.toString() ?? '';
      if (eventId.isNotEmpty) attendedEventIds.add(eventId);
    }
    if (attendedEventIds.isEmpty) return OrganizerReviewEligibility.notAttended;

    // Is one of them an event of this organizer?
    final events = await firestore
        .collection('events')
        .where('organizerId', isEqualTo: organizerId)
        .get();
    final attended = events.docs.any((d) => attendedEventIds.contains(d.id));
    return attended
        ? OrganizerReviewEligibility.allowed
        : OrganizerReviewEligibility.notAttended;
  }

  // --------------------------------------------------------------- write

  /// Saves the review. Returns its id (= the user's uid).
  Future<Result<String>> postReview({
    required String organizerId,
    required int rating,
    required String text,
    required bool isAnonymous,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to continue'));
      }

      final eligibility = await _eligibility(organizerId, user.uid);
      if (eligibility != OrganizerReviewEligibility.allowed) {
        return Result.failure(FirebaseFailure(eligibility.message));
      }

      // The real name / photo are only read (and saved) when not anonymous.
      var authorName = 'Anonymous';
      String? authorImageUrl;
      if (!isAnonymous) {
        final userDoc = await firestore.collection('users').doc(user.uid).get();
        final data = userDoc.data();
        final savedName = (data?['name'] as String?)?.trim();
        authorName = (savedName != null && savedName.isNotEmpty)
            ? savedName
            : (user.displayName ?? 'Attendee');
        final image = data?['imageUrl'] as String?;
        authorImageUrl = (image == null || image.isEmpty) ? null : image;
      }

      await _reviews(organizerId).doc(user.uid).set({
        'reviewerId': user.uid,
        'organizerId': organizerId,
        'authorName': authorName,
        'authorImageUrl': authorImageUrl,
        'isAnonymous': isAnonymous,
        'rating': rating,
        'text': text,
        'verified': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return Result.success(user.uid);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
