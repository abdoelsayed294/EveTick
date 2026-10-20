import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/organizer_profile/data/models/organizer_profile_model.dart';

class OrganizerProfileRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Result<OrganizerProfile>> getProfile(String organizerId) async {
    try {
      final userDoc = await firestore.collection('users').doc(organizerId).get();
      final user = userDoc.data();
      if (user == null) {
        return Result.failure(FirebaseErrorHandler.notFound('Organizer not found'));
      }

      final snapshot = await firestore
          .collection('events')
          .where('organizerId', isEqualTo: organizerId)
          .get();

      final events = <HomeEvent>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] as String?;
        if (status != null && status != 'live') continue;
        try {
          events.add(HomeEvent.fromJson({'eventId': doc.id, ...data}));
        } catch (_) {
        }
      }

      final now = DateTime.now();
      bool isPast(HomeEvent e) {
        final end = DateTime.tryParse(e.endAt) ?? DateTime.tryParse(e.startAt);
        return end != null && end.isBefore(now);
      }

      int byStart(HomeEvent a, HomeEvent b) => (DateTime.tryParse(a.startAt) ??
              DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(DateTime.tryParse(b.startAt) ??
              DateTime.fromMillisecondsSinceEpoch(0));

      final upcoming = events.where((e) => !isPast(e)).toList()..sort(byStart);
      final past = events.where(isPast).toList()
        ..sort((a, b) => byStart(b, a));

      final latest = [...upcoming, ...past]
          .map((e) => e.coverImageUrl)
          .firstWhere((url) => url.isNotEmpty, orElse: () => '');

      final name = ((user['name'] as String?) ?? '').trim();
      final image = (user['imageUrl'] as String?)?.trim();
      final bio = (user['bio'] as String?)?.trim();

      return Result.success(
        OrganizerProfile(
          id: organizerId,
          name: name.isEmpty ? 'Organizer' : name,
          avatarUrl: (image == null || image.isEmpty) ? null : image,
          bannerUrl: latest.isEmpty ? null : latest,
          bio: (bio == null || bio.isEmpty) ? null : bio,
          isVerified: user['isVerified'] as bool? ?? false,
          followers: (user['followers'] as num?)?.toInt() ?? 0,
          eventsHosted: events.length,
          upcomingEvents: upcoming,
          pastEvents: past,
        ),
      );
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
