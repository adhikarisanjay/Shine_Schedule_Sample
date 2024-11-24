import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'register_provider.g.dart';

@riverpod
class RegisterActivity extends _$RegisterActivity {
  bool isSignedIn = false;

  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<String?> register(
      {required String firstName,
      required String lastName,
      required String email,
      required String password,
      required String phoneNumber,
      required BuildContext context}) async {
    try {
      final _firestore = FirebaseFirestore.instance;

      // Check if email already exists in Firestore
      QuerySnapshot emailQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        // Email already exists, return message
        state = const AsyncValue.data("Email already exists.");
        return "Email already exists.";
      }

      // Proceed with registration
      final _auth = FirebaseAuth.instance;
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      // Save additional details to Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
      });

      await user.sendEmailVerification();
      state = const AsyncValue.data(null);

      return "Registered Successfully";
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return e.toString();
    }
  }
}
