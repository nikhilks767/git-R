// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  TextEditingController imagecontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController singercontroller = TextEditingController();
  TextEditingController musiccontroller = TextEditingController();
  TextEditingController ratingcontroller = TextEditingController();
  TextEditingController lyricscontroller = TextEditingController();
  TextEditingController videocontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Add a Song",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                  controller: imagecontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Image Path")),
              SizedBox(height: 10),
              TextFormField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Song Name")),
              SizedBox(height: 8),
              TextFormField(
                  controller: singercontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Singers")),
              SizedBox(height: 8),
              TextFormField(
                  controller: musiccontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Music")),
              SizedBox(height: 8),
              TextFormField(
                  controller: ratingcontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Rating")),
              SizedBox(height: 8),
              TextFormField(
                  controller: lyricscontroller,
                  maxLines: 10,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Lyrics")),
              SizedBox(height: 8),
              TextFormField(
                  controller: videocontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Video Path")),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        addSong();
                      },
                      child: Text("Add Song")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void addSong() {
    String image = imagecontroller.text.trim();
    String name = namecontroller.text.trim();
    String nameLowerCase = name.toLowerCase();
    String singer = singercontroller.text.trim();
    String music = musiccontroller.text.trim();
    String rating = ratingcontroller.text.trim();
    String lyrics = lyricscontroller.text.trim();
    String video = videocontroller.text.trim();
    if (image.isEmpty ||
        name.isEmpty ||
        singer.isEmpty ||
        music.isEmpty ||
        rating.isEmpty ||
        lyrics.isEmpty ||
        video.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "Please fill in all fields",
          backgroundColor: ColorConstants.red,
        ),
      );
      return;
    }

    FirebaseFunctions.addSong(
      image: image,
      name: name,
      nameLowerCase: nameLowerCase,
      singer: singer,
      music: music,
      rating: rating,
      lyrics: lyrics,
      video: video,
    ).then((response) {
      if (response == null) {
        print("Song Added Successfully");
        showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: "Song Added Successfully",
            ));
        Get.back(result: context);
      } else {
        showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: "Error : $response",
              backgroundColor: ColorConstants.red,
            ));
      }
    }).catchError((error) {
      showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "Error : $error",
            backgroundColor: ColorConstants.red,
          ));
    });
  }
}
