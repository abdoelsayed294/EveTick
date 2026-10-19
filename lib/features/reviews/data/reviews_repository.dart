import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/reviews/data/models/review_eligibility_model.dart';
import 'package:evetick/features/reviews/data/models/review_model.dart';
import 'package:evetick/features/reviews/data/models/review_summary_model.dart';
import 'package:evetick/features/reviews/data/models/reviews_data_model.dart';
import 'package:evetick/features/reviews/data/models/reviews_page_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

/// Reviews live in `events/{eventId}/reviews/{userId}` (one per user).
/// The rating summary is counted with Firestore count queries, nothing is
/// stored on the event, so nobody can fake it from the app.
class ReviewsRepository {
  static const int pageSize = 10;
  static const int maxPhotos = 4;
  static const int maxPhotoBytes = 5 * 1024 * 1024;
  static const List<String> allowedExtensions = ['png', 'jpg', 'jpeg'];
  static const int minTextLength = 10;
  static const int maxTextLength = 1000;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  CollectionReference<Map<String, dynamic>> _reviews(String eventId) =>
      firestore.collection('events').doc(eventId).collection('reviews');

  // ---------------------------------------------------------------- read

  /// First page + rating summary + whether the user may write a review.
  Future<Result<ReviewsData>> getReviews({required String eventId}) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to see reviews'));
      }

      final helpfulKeys = await _helpfulKeys(user.uid);

      // Started together, awaited one by one.
      final summaryFuture = _loadSummary(eventId);
      final pageFuture = _loadPage(
        eventId: eventId,
        cursor: null,
        userId: user.uid,
        helpfulKeys: helpfulKeys,
      );
      final eligibilityFuture = _eligibility(eventId, user.uid);

      final summary = await summaryFuture;
      final page = await pageFuture;
      final eligibility = await eligibilityFuture;

      return Result.success(
        ReviewsData(
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
  Future<Result<ReviewsPage>> getMoreReviews({
    required String eventId,
    required Object? cursor,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to see reviews'));
      }
      final helpfulKeys = await _helpfulKeys(user.uid);
      final page = await _loadPage(
        eventId: eventId,
        cursor: cursor,
        userId: user.uid,
        helpfulKeys: helpfulKeys,
      );
      return Result.success(page);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<ReviewSummary> _loadSummary(String eventId) async {
    final counts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    await Future.wait([
      for (var star = 1; star <= 5; star++)
        _reviews(eventId)
            .where('rating', isEqualTo: star)
            .count()
            .get()
            .then((snapshot) => counts[star] = snapshot.count ?? 0),
    ]);
    return ReviewSummary(counts: counts);
  }

  Future<ReviewsPage> _loadPage({
    required String eventId,
    required Object? cursor,
    required String userId,
    required Set<String> helpfulKeys,
  }) async {
    Query<Map<String, dynamic>> query = _reviews(eventId)
        .orderBy('createdAt', descending: true)
        .limit(pageSize);
    if (cursor is DocumentSnapshot<Map<String, dynamic>>) {
      query = query.startAfterDocument(cursor);
    }

    final snapshot = await query.get();

    final reviews = <Review>[];
    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        reviews.add(
          Review.fromJson(
            {
              ...data,
              'reviewId': doc.id,
              'createdAt': (data['createdAt'] as Timestamp?)?.toDate(),
            },
            currentUserId: userId,
            helpfulKeys: helpfulKeys,
          ),
        );
      } catch (_) {
        // A malformed review must not break the whole list.
      }
    }

    return ReviewsPage(
      reviews: reviews,
      hasMore: snapshot.docs.length == pageSize,
      cursor: snapshot.docs.isEmpty ? cursor : snapshot.docs.last,
    );
  }

  /// Reviews the user marked helpful: `users/{uid}.helpfulReviewKeys`.
  Future<Set<String>> _helpfulKeys(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      return (doc.data()?['helpfulReviewKeys'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toSet();
    } catch (_) {
      return <String>{}; // only used to colour the thumbs
    }
  }

  /// One review per user, and only for events the user has a paid order for.
  Future<ReviewEligibility> _eligibility(String eventId, String uid) async {
    final existing = await _reviews(eventId).doc(uid).get();
    if (existing.exists) return ReviewEligibility.alreadyReviewed;

    final orders = await firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .where('eventId', isEqualTo: eventId)
        .get();
    final attended = orders.docs.any((d) => d.data()['status'] == 'confirmed');
    return attended ? ReviewEligibility.allowed : ReviewEligibility.notAttended;
  }

  // ------------------------------------------------------------- helpful

  /// Adds / removes the user's "Helpful" vote. Done in a transaction so a
  /// stale screen can never count the same vote twice.
  Future<Result<void>> setHelpful({
    required String eventId,
    required String reviewId,
    required bool helpful,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to continue'));
      }

      final reviewRef = _reviews(eventId).doc(reviewId);
      final userRef = firestore.collection('users').doc(user.uid);
      final key = Review.helpfulKey(eventId, reviewId);

      await firestore.runTransaction((tx) async {
        final userSnap = await tx.get(userRef);
        final keys = (userSnap.data()?['helpfulReviewKeys'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toSet();
        if (keys.contains(key) == helpful) return; // already in that state

        tx.update(reviewRef, {
          'helpfulCount': FieldValue.increment(helpful ? 1 : -1),
        });
        tx.set(
          userRef,
          {
            'helpfulReviewKeys': helpful
                ? FieldValue.arrayUnion([key])
                : FieldValue.arrayRemove([key]),
          },
          SetOptions(merge: true),
        );
      });
      return Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  // --------------------------------------------------------------- write

  /// Returns `null` when the user cancels the picker.
  Future<Result<File?>> pickPhoto() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return Result.success(null);
      return Result.success(File(image.path));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<bool> isValidPhoto(File file) async {
    final extension = file.path.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) return false;
    return await file.length() <= maxPhotoBytes;
  }

  /// Saves the review. Returns its id (= the user's uid).
  Future<Result<String>> postReview({
    required String eventId,
    required int rating,
    required String text,
    required bool isAnonymous,
    required List<File> photos,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to continue'));
      }

      final eligibility = await _eligibility(eventId, user.uid);
      if (eligibility != ReviewEligibility.allowed) {
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

      final photoUrls = <String>[];
      for (var i = 0; i < photos.length; i++) {
        final extension = photos[i].path.split('.').last.toLowerCase();
        final ref = storage.ref().child(
              'review_photos/$eventId/${user.uid}/'
              '${DateTime.now().millisecondsSinceEpoch}_$i.$extension',
            );
        await ref.putFile(photos[i]);
        photoUrls.add(await ref.getDownloadURL());
      }

      await _reviews(eventId).doc(user.uid).set({
        'reviewId': user.uid,
        'eventId': eventId,
        'userId': user.uid,
        'authorName': authorName,
        'authorImageUrl': authorImageUrl,
        'isAnonymous': isAnonymous,
        'rating': rating,
        'text': text,
        'photoUrls': photoUrls,
        'verified': true,
        'helpfulCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return Result.success(user.uid);
    } on FirebaseException catch (e) {
      return Result.failure(
        e.plugin == 'firebase_storage'
            ? FirebaseErrorHandler.handleStorage(e)
            : FirebaseErrorHandler.handleFirestore(e),
      );
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
