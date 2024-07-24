// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class TypeModel {
  final String id;
  final String image;
  final String history;
  final String img1;
  final String img2;
  final String img3;
  final String type1;
  final String type2;
  final String type3;

  TypeModel({
    required this.id,
    required this.image,
    required this.history,
    required this.img1,
    required this.img2,
    required this.img3,
    required this.type1,
    required this.type2,
    required this.type3,
  });

  factory TypeModel.fromMap(Map<String, dynamic> map, String documentId) =>
      TypeModel(
        id: documentId,
        image: map["image"] ?? 'No image available',
        history: map["history"] ?? 'No history available',
        img1: map["gitrTypes"]["img1"] ?? 'No img1 available',
        img2: map["gitrTypes"]["img2"] ?? 'No img2 available',
        img3: map["gitrTypes"]["img3"] ?? 'No img3 available',
        type1: map["gitrTypes"]["type1"] ?? 'No type1 available',
        type2: map["gitrTypes"]["type2"] ?? 'No type2 available',
        type3: map["gitrTypes"]["type3"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "image": image,
        "history": history,
        "img1": img1,
        "img2": img2,
        "img3": img3,
        "type1": type1,
        "type2": type2,
        "type3": type3,
      };

  static Future<TypeModel?> getById(String id) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("gitrType").doc(id).get();
      if (doc.exists) {
        return TypeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print("No docType with this id : $id");
        return null;
      }
    } catch (e) {
      print("Error Fetching $e");
      return null;
    }
  }
}
