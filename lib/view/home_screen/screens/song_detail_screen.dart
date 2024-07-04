// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/model/song.dart';
import 'package:gitr/view/home_screen/screens/lyric_page.dart';
import 'package:youtube_player_iframe_plus/youtube_player_iframe_plus.dart';

class SongDetailScreen extends StatefulWidget {
  final int index;
  const SongDetailScreen({super.key, required this.index});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  List<SongModel> songs = [];
  bool isLoading = true;
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    loadSong();
  }

  Future<void> loadSong() async {
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
      isLoading = false;
      initializeVideoController();
    });
  }

  void initializeVideoController() {
    var song = songs[widget.index];
    final videoID = YoutubePlayerController.convertUrlToId(song.video);
    if (videoID != null) {
      _controller = YoutubePlayerController(
          initialVideoId: videoID,
          params: YoutubePlayerParams(
            showVideoAnnotations: false,
            strictRelatedVideos: true,
            autoPlay: false,
            showFullscreenButton: true,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (widget.index < 0 || widget.index >= songs.length) {
      return Scaffold(
        body: Center(child: Text("Invalid song index")),
      );
    }
    var song = songs[widget.index];
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: ColorConstants.amberShade200,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: NetworkImage(song.image),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name : ${song.songName}"),
                      SizedBox(height: 15),
                      Text("Singers : ${song.singer}"),
                      SizedBox(height: 15),
                      Text("Music : ${song.music}"),
                      SizedBox(height: 15),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Rating : ${song.rating}"),
                          SizedBox(width: 3),
                          Icon(Icons.star,
                              color: ColorConstants.amber, size: 15)
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30),
              Card(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(),
                      child: Text(
                        maxLines: 15,
                        overflow: TextOverflow.fade,
                        song.lyrics,
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                            onPressed: () async {
                              await Get.to(() => LyricPage(
                                  lyrics: song.lyrics,
                                  songName: song.songName));
                            },
                            icon: Icon(Icons.open_in_full, size: 17)))
                  ],
                ),
              ),
              SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: YoutubePlayerIFramePlus(
                  controller: _controller,
                  aspectRatio: 16 / 9,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
