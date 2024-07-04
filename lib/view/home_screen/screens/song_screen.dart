// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/model/song.dart';
import 'package:gitr/view/home_screen/screens/song_detail_screen.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({super.key});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  List<SongModel> songs = [];
  bool isLoading = true;
  @override
  void initState() {
    loadSong();
    super.initState();
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
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: SearchBar(
              backgroundColor:
                  MaterialStatePropertyAll(ColorConstants.amberShade200),
              overlayColor:
                  MaterialStatePropertyAll(ColorConstants.amberShade300),
              surfaceTintColor:
                  MaterialStatePropertyAll(ColorConstants.transparent),
              hintText: "Search Song",
              elevation: MaterialStatePropertyAll(3),
              trailing: [
                Icon(
                  Icons.search,
                  color: ColorConstants.primaryBlack.withOpacity(0.6),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          toolbarHeight: 90,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
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
                        leading: Container(
                          width: 55,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image: NetworkImage(song.image),
                                  fit: BoxFit.cover)),
                        ),
                        title: Text(song.songName),
                        subtitle: Text(song.singer),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              song.rating,
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(width: 3),
                            Icon(Icons.star,
                                color: ColorConstants.amber, size: 15),
                            SizedBox(width: 8),
                          ],
                        ),
                        onTap: () async {
                          await Get.to(() => SongDetailScreen(
                                index: index,
                              ));
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                ),
              ));
  }
}
