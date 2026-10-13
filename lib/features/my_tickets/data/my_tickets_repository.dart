import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/my_tickets/data/models/my_ticket_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyTicketsRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Every order of the signed-in user, soonest event first.
  Future<Result<List<MyTicket>>> getMyTickets() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to see your tickets'));
      }

      // Single filter: no composite index needed; sorted below.
      final snapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .get();

      final tickets = snapshot.docs
          .map((doc) => MyTicket.fromJson(doc.data()))
          .toList()
        ..sort(_bySoonest);

      return Result.success(tickets);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  static int _bySoonest(MyTicket a, MyTicket b) {
    final aDate = a.startDate;
    final bDate = b.startDate;
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return aDate.compareTo(bDate);
  }
}
