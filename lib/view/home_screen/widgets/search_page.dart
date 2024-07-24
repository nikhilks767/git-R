// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/model/song.dart';
import 'package:gitr/view/home_screen/screens/song_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends SearchDelegate<String> {
  List<SongModel> songs = [];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, '');
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    String searchQuery = query.toLowerCase();
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection("songs")
          .where('songNameLowerCase', isGreaterThanOrEqualTo: searchQuery)
          .where('songNameLowerCase', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Lottie.asset("assets/animations/Animation - gitr.json",
                  height: 150));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No results Found"));
        }
        if (query.isEmpty) {
          return Center(
            child: Text("Enter a Song Name to Search",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: ColorConstants.primaryBlack.withOpacity(0.5))),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var song =
                  SongModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.singer),
                onTap: () {
                  Get.to(() => SongDetailScreen(song: song));
                },
              );
            });
      },
    );
  }
}
