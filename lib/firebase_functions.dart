import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFunctions {
  Future<String?> signUpUser(
      {required String email, required String pass, String? name}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<String?> signInUser(
      {required String email, required String pass}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
