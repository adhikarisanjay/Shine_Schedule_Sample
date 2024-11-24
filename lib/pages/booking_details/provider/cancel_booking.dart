import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'cancel_booking.g.dart';

@riverpod
class CancelBooking extends _$CancelBooking {
  @override
  FutureOr<String?> build() {
    // No initialization needed
  }

  Future<String?> cancelBooking(String bookingId) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      try {
        final bookingRef = firestore.collection('bookings').doc(bookingId);
        await bookingRef.update({
          'status': "Cancelled",
          'cancellationDate': Timestamp.now(),
        });

        state = const AsyncValue.data(
            "Your appointment cancel successfully! Business will contact you soon for refund");
        return "";
      } catch (e) {
        state = AsyncValue.error(e.toString(), StackTrace.current);
      }
    } else {
      state = AsyncValue.error(
          "No user is currently logged in.", StackTrace.current);
    }
  }
}
