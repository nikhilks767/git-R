// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/model/song.dart';
import 'package:gitr/view/home_screen/screens/song_detail_screen.dart';
import 'package:gitr/view/home_screen/widgets/search_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({super.key});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  TextEditingController searchcontroller = TextEditingController();
  List<SongModel> songs = [];
  bool isLoading = true;
  @override
  void initState() {
    loadSong();
    super.initState();
  }

  Future<void> loadSong() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("songs").get();
    List<SongModel> loadedSongs = [];
    for (var doc in querySnapshot.docs) {
      SongModel? songModel = await FirebaseFunctions().getSongs(doc.id);
      if (songModel != null) {
        loadedSongs.add(songModel);
      }
    }
    setState(() {
      songs = loadedSongs;
      isLoading = !isLoading;
    });
  }

  Future<void> _refreshValue() async {
    await loadSong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstants.primaryBlack,
          title: Text(
            "Search a Song",
            style: GoogleFonts.poppins(
                color: ColorConstants.amber, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await showSearch(context: context, delegate: SearchPage());
                },
                icon: Icon(Icons.search, color: ColorConstants.amber)),
            SizedBox(width: 15)
          ],
          toolbarHeight: 70,
        ),
        body: isLoading
            ? Center(
                child: Lottie.asset("assets/animations/Animation - gitr.json",
                    height: 150),
              )
            : RefreshIndicator(
                onRefresh: _refreshValue,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView.separated(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      var song = songs[index];
                      return Card(
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          contentPadding: EdgeInsets.all(7),
                          leading: isLoading
                              ? CircularProgressIndicator()
                              : Container(
                                  width: 55,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          image: NetworkImage(song.image),
                                          fit: BoxFit.cover)),
                                ),
                          title: Text(song.songName),
                          subtitle: Text(
                            song.singer,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            // maxLines: 2
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                song.rating,
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(width: 3),
                              Icon(Icons.star,
                                  color: ColorConstants.amber, size: 16),
                              SizedBox(width: 8),
                            ],
                          ),
                          onTap: () {
                            Get.to(() => SongDetailScreen(
                                  song: song,
                                ));
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                  ),
                ),
              ));
  }
}
