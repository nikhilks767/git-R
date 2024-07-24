// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gitr/model/song.dart';
import 'package:gitr/model/type.dart';
import 'package:gitr/model/user.dart';

class FirebaseFunctions {
// Signing up
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

//  Login user
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

// LogOut user
  static Future<String?> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

// Password resetting
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

// Getting all users
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

// Getting user profile based on user id
  Future<UserModel?> getUserProfile(String userId) async {
    print('Fetching user profile for ID: $userId');
    return await UserModel.getById(userId);
  }

// Adding songs
  static Future<String?> addSong({
    String? id,
    required String image,
    required String name,
    String? nameLowerCase,
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
          songNameLowerCase: nameLowerCase,
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

// Getting songs
  Future<SongModel?> getSongs(String id) async {
    print("Fetching Song with specific id : $id");
    return await SongModel.getById(id);
  }

// Getting guitar types
  Future<TypeModel?> getGitrTypes(String id) async {
    return await TypeModel.getById(id);
  }
}
