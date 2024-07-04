// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

// import 'dart:convert';

// UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

// String userModelToJson(UserModel data) => json.encode(data.toJson());

// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? password;
  final int? phone;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.password,
    this.phone,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) =>
      UserModel(
        id: documentId,
        name: map["name"],
        email: map["email"],
        password: map["password"],
        phone: map["phone"],
      );

  Map<String, dynamic> toMap() => {
        "uid": id,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
      };

  Future<void> saveUser() async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(id).set(toMap());
    } catch (e) {
      print("Error Saving User : $e");
    }
  }

  static Future<UserModel?> getById(String id) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("users").doc(id).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print('No user found with id: $id');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }
}
