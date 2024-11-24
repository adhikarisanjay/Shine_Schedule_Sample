import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shine_schedule/config/network.dart';
import 'package:shine_schedule/pages/booking_details/model/booking_details.dart';
import 'package:shine_schedule/utils/constant.dart';

part 'fetch_booking_details.g.dart';

@riverpod
class FetchBookingDetails extends _$FetchBookingDetails {
  @override
  FutureOr<List<BookingDetails>?> build() {
    return fetchDetails();
  }

  Future<List<BookingDetails>?> fetchDetails() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final user = auth.currentUser;

    if (!await NetworkUtil.isConnected()) {
      state = AsyncValue.error(Constant.networkError, StackTrace.current);
      return null;
    }

    if (user != null) {
      try {
        final bookingsCollection = await firestore
            .collection('bookings')
            .where('email', isEqualTo: user.email)
            .get();

        List<BookingDetails> bookings = bookingsCollection.docs.map((doc) {
          return BookingDetails.fromDocument(doc);
        }).toList();

        // Sort by date and time in descending order
        bookings.sort((a, b) {
          int dateComparison = b.date.compareTo(a.date);
          if (dateComparison != 0) return dateComparison;

          // Assuming you want to sort by the first time entry if multiple times exist
          if (a.time.isNotEmpty && b.time.isNotEmpty) {
            return b.time.first.compareTo(a.time.first);
          }
          return 0; // Handle cases where time lists might be empty
        });

        state = AsyncValue.data(bookings);
        return bookings;
      } on FirebaseException catch (e) {
        print('FirebaseException: ${e.message}');

        if (e.code == 'unavailable') {
          state = AsyncValue.error(
              'Network issue: ${e.message}', StackTrace.current);
        } else {
          state = AsyncValue.error(
              'FirebaseException: ${e.message}', StackTrace.current);
        }

        return null;
      } catch (e) {
        state = AsyncValue.error(e.toString(), StackTrace.current);
        return null;
      }
    }

    return null;
  }
}
