import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shine_schedule/common_model.dart/user_model.dart';

part 'profile_provider.g.dart';

@riverpod
class EditProfile extends _$EditProfile {
  bool isSignedIn = false;

  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<String?> editProfile(UserModel userModel) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final User? user = auth.currentUser;

    if (user != null) {
      try {
        await firestore
            .collection('users')
            .doc(user.uid)
            .update(userModel.toJson());
        state = const AsyncValue.data("Profile edited Sucessfully.");

        return "Profile edited Sucessfully.";
      } catch (e) {
        state = AsyncValue.error(e.toString(), StackTrace.current);
        return e.toString();
      }
    }
    return null;
  }
}
