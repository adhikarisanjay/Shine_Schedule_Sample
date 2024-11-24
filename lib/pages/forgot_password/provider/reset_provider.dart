import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shine_schedule/utils/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'reset_provider.g.dart';

@riverpod
class ResetActivity extends _$ResetActivity {
  bool isSignedIn = false;

  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<String?> fogotPassword({required String email}) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final userQuery = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        // Email does not exist in the 'users' collection
        state = const AsyncValue.data("Email does not exist.");
        return null;
      }

      final auth = FirebaseAuth.instance;
      await auth.sendPasswordResetEmail(email: email);
      state = const AsyncValue.data(
          "Please check your email to reset your password");
      SharedPreferenced().setLoginStatus(true);
      return "Please check your email to reset your password";
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return e.toString();
    }
  }
}
