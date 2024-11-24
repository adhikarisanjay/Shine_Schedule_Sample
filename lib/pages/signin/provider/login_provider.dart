import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shine_schedule/utils/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
part 'login_provider.g.dart';

@riverpod
class LoginActivity extends _$LoginActivity {
  bool isSignedIn = false;

  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<String?> login(
      {required String email, required String password}) async {
    try {
      final auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null && user.emailVerified) {
        // Email is verified, fetch user details
        final firestore = FirebaseFirestore.instance;
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          // Return user details as a success message
          state = const AsyncValue.data("Login successful.");
          SharedPreferenced().setLoginStatus(true);
          return "Login successful.";
        }
      } else {
        // Email is not verified, resend verification email
        await user!.sendEmailVerification();
        state = const AsyncValue.data("confirmSignUp");

        return "confirmSignUp";
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return e.toString();
    }
    return null;
  }

  Future<void> signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await auth.signOut();
      await googleSignIn.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
