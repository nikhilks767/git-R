// To parse this JSON data, do
//
//     final songModel = songModelFromJson(jsonString);

// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class SongModel {
  final String id;
  final String image;
  final String songName;
  final String? songNameLowerCase;
  final String singer;
  final String music;
  final String rating;
  final String lyrics;
  final String video;

  SongModel({
    required this.id,
    required this.image,
    required this.songName,
    this.songNameLowerCase,
    required this.singer,
    required this.music,
    required this.rating,
    required this.lyrics,
    required this.video,
  });

  factory SongModel.fromMap(Map<String, dynamic> map, String documentId) =>
      SongModel(
        id: documentId,
        image: map["image"],
        songName: map["songName"],
        songNameLowerCase: map["songNameLowerCase"],
        singer: map["singer"],
        music: map["music"],
        rating: map["rating"],
        lyrics: map["lyrics"],
        video: map["video"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "image": image,
        "songName": songName,
        "songNameLowerCase": songNameLowerCase,
        "singer": singer,
        "music": music,
        "rating": rating,
        "lyrics": lyrics,
        "video": video,
      };

  Future<void> saveSong() async {
    try {
      await FirebaseFirestore.instance.collection("songs").doc(id).set(toMap());
    } catch (e) {
      print(e);
    }
  }

  static Future<SongModel?> getById(String id) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("songs").doc(id).get();
      if (doc.exists) {
        return SongModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print("No song with this id : $id");
        return null;
      }
    } catch (e) {
      print("Error fetching song : $e");
      return null;
    }
  }
}
