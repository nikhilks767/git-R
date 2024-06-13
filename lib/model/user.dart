// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  final int? uid;
  final String? username;
  final String? email;
  final String? password;

  Users({
    this.uid,
    this.username,
    this.email,
    this.password,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "password": password,
      };
}
