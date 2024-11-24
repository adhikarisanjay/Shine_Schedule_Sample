import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'gmail_register.g.dart';

@riverpod
class GmailRegister extends _$GmailRegister {
  @override
  FutureOr<String?> build() async {
    // Initial state is set to null indicating no user is signed in
    return null;
  }

  Future<String?> signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        state = AsyncValue.error("User Cancel Signup", StackTrace.current);
        return "User Cancel Signup";
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if user already exists in Firestore
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // User doesn't exist, add to Firestore
          await firestore.collection('users').doc(user.uid).set({
            'firstName': user.displayName?.split(" ")[0] ?? "",
            'lastName': user.displayName?.split(" ").last ?? "",
            'email': user.email,
            'phoneNumber': user.phoneNumber,
          });
          state = const AsyncValue.data(
            "User Login successfully",
          );
          return "User Login successfully";
        } else {
          state = const AsyncValue.data(
            "User Login successfully",
          );
          return "User Login successfully";
        }
      }

      // Update the state to the signed-in user
    } catch (e) {
      // Update the state with the error
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return e.toString();
    }
    return null;
  }
}
