import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'booking_post.g.dart';

@riverpod
class PostBookingInfo extends _$PostBookingInfo {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<String?> bookingInfo({
    required String serviceName,
    required String date,
    required List<String> time,
    required String userName,
    required String email,
    required String paymentConfirmation,
    required int amount,
    String? imagePath,
    required double fullAmount,
    required String createdBy,
    required String category,
  }) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;
      final user = auth.currentUser;
      // Convert date and times to Timestamps
      DateTime dateOnly = DateFormat('yyyy-MM-dd').parse(date);
      List<Timestamp> timeTimestamps = time.map((timeString) {
        DateTime timeParsed = DateFormat.jm().parse(timeString);
        DateTime combinedDateTime = DateTime(
          dateOnly.year,
          dateOnly.month,
          dateOnly.day,
          timeParsed.hour,
          timeParsed.minute,
        );
        return Timestamp.fromDate(combinedDateTime);
      }).toList();
      String imageUrl = imagePath ?? '';
      if (imagePath != null && imagePath.isNotEmpty) {
        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('bookings/${DateTime.now().millisecondsSinceEpoch}.png');
        final uploadTask = storageRef.putFile(File(imagePath));
        final taskSnapshot = await uploadTask;
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      await firestore.collection('bookings').add({
        'serviceName': serviceName,
        'date': Timestamp.fromDate(dateOnly),
        'time': timeTimestamps,
        'userName': userName,
        'email': email,
        'paymentConfirmation': paymentConfirmation,
        'amount': amount,
        'isCancelled': false,
        'fullAmount': fullAmount,
        'category': category,
        'imageUrl': imageUrl, // Add image URL
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'createdBy': user?.uid,
        'userId': user?.uid,
        'updatedBy': user?.uid,
        'status': 'Confirmed',
      });
//userid in created at
      // Reference to the date document
      DocumentReference dateDoc = firestore.collection('dates').doc(date);

      // Remove the booked times from the dates collection
      await dateDoc.update({
        'times': FieldValue.arrayRemove(timeTimestamps),
      });

      // Log the completion of the update

      state = const AsyncValue.data('Booking successfully registered');
      return 'Booking successfully registered';
    } catch (e) {
      // Log the error
      print('Error during booking: $e');
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return e.toString();
    }
  }
}
