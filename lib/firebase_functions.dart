// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gitr/model/song.dart';
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
      log('FirebaseAuthException: ${e.message}');
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

  static Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("users").get();
      return querySnapshot.docs
          .map((doc) =>
              UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error : $e");
      return [];
    }
  }

  Future<UserModel?> getUserProfile(String userId) async {
    print('Fetching user profile for ID: $userId');
    return await UserModel.getById(userId);
  }

  Future<String?> signInAdmin(
      {required String email, required String pass}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<String?> addSong({
    String? id,
    required String image,
    required String name,
    required String singer,
    required String music,
    required String rating,
    required String lyrics,
    required String video,
  }) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("songs").doc(id).get();
      SongModel newSong = SongModel(
          id: doc.id,
          image: image,
          songName: name,
          singer: singer,
          music: music,
          rating: rating,
          lyrics: lyrics,
          video: video);
      await newSong.saveSong();
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<SongModel?> getSongs(String id) async {
    print("Fetching Song with with specific id : $id");
    return await SongModel.getById(id);
  }
}
