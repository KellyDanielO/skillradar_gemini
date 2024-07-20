import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/widgets/error_widgets.dart';

class AuthController {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth == null) {
        return null;
      } else {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } on Exception catch (e) {
      log('exception->$e');

      errorWidget(message: 'Error!');
    }
    return null;
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<UserCredential?> signUpEmailPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorWidget(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        errorWidget(message: 'The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
      errorWidget(message: 'Error!');
    }
    return null;
  }

  Future<UserCredential?> signInEmailPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorWidget(message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        errorWidget(message: 'Wrong password provided for that user.');
      }
    } catch (e) {
      log(e.toString());
      errorWidget(message: 'Error!');
    }
    return null;
  }
}
