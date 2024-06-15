import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gitr/model/user.dart';

class FirebaseFunctions {
  Future<String?> signUpUser(
      {required String email,
      required String pass,
      required String name,
      required int phone}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      await userCredential.user?.updateProfile(displayName: name);

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        password: pass,
        phone: phone,
      );
      await newUser.saveUser();
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

  Future<UserModel?> getUserProfile(String userId) async {
    print('Fetching user profile for ID: $userId');
    return await UserModel.getById(userId);
  }
}
