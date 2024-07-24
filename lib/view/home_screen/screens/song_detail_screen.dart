// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/model/song.dart';
import 'package:gitr/view/home_screen/screens/lyric_page.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_player_iframe_plus/youtube_player_iframe_plus.dart';

class SongDetailScreen extends StatefulWidget {
  final SongModel song;
  const SongDetailScreen({super.key, required this.song});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  late YoutubePlayerController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeVideoController();
  }

  void initializeVideoController() {
    final videoID = YoutubePlayerController.convertUrlToId(widget.song.video);
    if (videoID != null) {
      _controller = YoutubePlayerController(
          initialVideoId: videoID,
          params: YoutubePlayerParams(
            useHybridComposition: false,
            showVideoAnnotations: false,
            strictRelatedVideos: true,
            autoPlay: false,
            showFullscreenButton: true,
          ));
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Lottie.asset("assets/animations/Animation - gitr.json",
                  height: 150))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: 70),
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
                                  image: NetworkImage(widget.song.image),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name : ${widget.song.songName}",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true),
                              SizedBox(height: 15),
                              Text("Singers : ${widget.song.singer}",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true),
                              SizedBox(height: 15),
                              Text("Music : ${widget.song.music}",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true),
                              SizedBox(height: 15),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Rating : ${widget.song.rating}"),
                                  SizedBox(width: 3),
                                  Icon(Icons.star,
                                      color: ColorConstants.amber, size: 15)
                                ],
                              ),
                            ],
                          ),
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
                              widget.song.lyrics,
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                  onPressed: () async {
                                    await Get.to(() => LyricPage(
                                        lyrics: widget.song.lyrics,
                                        songName: widget.song.songName));
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
