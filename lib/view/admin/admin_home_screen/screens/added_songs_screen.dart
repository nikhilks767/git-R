// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/model/song.dart';
import 'package:gitr/view/admin/admin_home_screen/admin_home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddedSongScreen extends StatefulWidget {
  const AddedSongScreen({super.key});

  @override
  State<AddedSongScreen> createState() => _AddedSongScreenState();
}

class _AddedSongScreenState extends State<AddedSongScreen> {
  var songList = <SongModel>[].obs;
  bool isLoading = true;
  Future<void> loadSong() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("songs").get();
    RxList<SongModel> loadedSongs = RxList();
    for (var doc in querySnapshot.docs) {
      SongModel? songModel = await FirebaseFunctions().getSongs(doc.id);
      if (songModel != null) {
        loadedSongs.add(songModel);
      }
    }
    setState(() {
      songList = loadedSongs;
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    loadSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: Lottie.asset("assets/animations/Animation - gitr.json",
                    height: 150),
              )
            : Obx(
                () {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: ListView.separated(
                      itemCount: songList.length,
                      itemBuilder: (context, index) {
                        var song = songList[index];
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
                          subtitle: Text(
                            song.singer,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            // maxLines: 2
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    contentPadding: EdgeInsets.all(20),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Are you sure",
                                          style: GoogleFonts.poppins(),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "you want to delete ${song.songName}?",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(),
                                        ),
                                        SizedBox(height: 50),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: 110,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    Get.back(result: context);
                                                  },
                                                  child: Text("Cancel")),
                                            ),
                                            SizedBox(
                                              width: 110,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    deleteSong(song.id);
                                                    Get.offAll(() =>
                                                        AdminHomeScreen());
                                                  },
                                                  child: Text("Delete")),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.delete,
                                  color: ColorConstants.red, size: 22)),
                        ));
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                    ),
                  );
                },
              ));
  }

  void deleteSong(String id) async {
    try {
      await FirebaseFirestore.instance.collection("songs").doc(id).delete();
      showTopSnackBar(Overlay.of(context),
          CustomSnackBar.success(message: "Song Deleted Successfully"));
      Get.back(result: context);
    } catch (e) {
      print("Error : $e");
    }
  }
}
