import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'update_appointment_provider.g.dart';

@riverpod
class UpdateBookingProvider extends _$UpdateBookingProvider {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<String?> updateBookingDetails({
    required String bookingId,
    required String newDate,
    required List<String> newTimes,
  }) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final bookingDoc =
          await firestore.collection('bookings').doc(bookingId).get();
      if (!bookingDoc.exists) {
        throw Exception("Booking not found");
      }

      final data = bookingDoc.data()!;
      final oldDate = (data['date'] as Timestamp).toDate();
      final oldTimes = (data['time'] as List<dynamic>)
          .map((e) => (e as Timestamp).toDate())
          .toList();

      DateTime newDateOnly = DateFormat('yyyy-MM-dd').parse(newDate);
      List<Timestamp> newTimeTimestamps = newTimes.map((timeString) {
        DateTime timeParsed = DateFormat.jm().parse(timeString);
        DateTime combinedDateTime = DateTime(
          newDateOnly.year,
          newDateOnly.month,
          newDateOnly.day,
          timeParsed.hour,
          timeParsed.minute,
        );
        return Timestamp.fromDate(combinedDateTime);
      }).toList();

      // Update old date document by restoring old times
      String oldFormattedDate = DateFormat('yyyy-MM-dd').format(oldDate);
      DocumentReference oldDateDoc =
          firestore.collection('dates').doc(oldFormattedDate);
      await oldDateDoc.update({
        'times': FieldValue.arrayUnion(
            oldTimes.map((time) => Timestamp.fromDate(time)).toList()),
      });

      // Update booking details
      await firestore.collection('bookings').doc(bookingId).update({
        'date': Timestamp.fromDate(newDateOnly),
        'time': newTimeTimestamps,
        'updatedAt': Timestamp.now(),
      });

      // Remove new booked times from the new date document
      DocumentReference newDateDoc = firestore.collection('dates').doc(newDate);
      await newDateDoc.update({
        'times': FieldValue.arrayRemove(newTimeTimestamps),
      });

      state = const AsyncValue.data("Booking updated successfully");

      return 'Booking updated successfully';
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return 'Failed to update booking: ${e.toString()}';
    }
  }
}
