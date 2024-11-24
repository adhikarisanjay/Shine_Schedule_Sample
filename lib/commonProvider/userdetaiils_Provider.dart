import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shine_schedule/common_model.dart/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'userdetaiils_Provider.g.dart';

@riverpod
class UserDetails extends _$UserDetails {
  @override
  FutureOr<UserModel?> build() {
    return userDetails();
  }

  Future<UserModel?> userDetails() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final user = auth.currentUser;
    if (user != null) {
      try {
        final doc = await firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          state = AsyncValue.data(UserModel.fromJson(doc.data()!));
          return UserModel.fromJson(doc.data()!);
        } else {
          return null;
        }
      } catch (e) {
        state = AsyncValue.error(e.toString(), StackTrace.current);
        return null;
      }
    }
    return null;
  }

  Future<void> updateDeviceToken(String newDeviceToken) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final user = auth.currentUser;
    if (user != null) {
      try {
        final doc = await firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          final currentDeviceToken = data?['deviceToken'] as String?;

          if (currentDeviceToken != newDeviceToken) {
            await firestore.collection('users').doc(user.uid).update({
              'deviceToken': newDeviceToken,
            });
            state = AsyncValue.data(
                UserModel.fromJson(data!..['deviceToken'] = newDeviceToken));
          }
        }
      } catch (e) {
        state = AsyncValue.error(e.toString(), StackTrace.current);
      }
    }
  }
}
