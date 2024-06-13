// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/view/home_screen/screens/chord_screen.dart';
import 'package:gitr/view/home_screen/screens/song_screen.dart';
import 'package:gitr/view/home_screen/screens/tuner_screen.dart';
import 'package:slidable_drawer/slidable_drawer.dart';

class GitRHomeScreen extends StatefulWidget {
  const GitRHomeScreen({super.key});

  @override
  State<GitRHomeScreen> createState() => _GitRHomeScreenState();
}

class _GitRHomeScreenState extends State<GitRHomeScreen> {
  final SlidableDrawerController _slidableDrawerController =
      SlidableDrawerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.primaryWhite,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                _slidableDrawerController.animateToOpen();
              },
              icon: Icon(Icons.menu)),
          title: Text("Welcome to GitR"),
          actions: [
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("Logout"),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          setState(() {
                            Get.back(result: context);
                          });
                        },
                      )
                    ])
          ],
        ),
        body: SlidableDrawer(
          innerDrawerController: _slidableDrawerController,
          drawerWidth: MediaQuery.of(context).size.width * 0.5,
          drawerBody: Drawer(
            shape: ContinuousRectangleBorder(),
            surfaceTintColor: ColorConstants.primaryWhite,
            backgroundColor: ColorConstants.primaryWhite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Image.asset(
                    "assets/images/logonround.png",
                    scale: 3.5,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text("Chords"),
                  onTap: () {
                    Get.to(ChordScreen());
                  },
                ),
                SizedBox(height: 5),
                ListTile(
                  leading: Icon(Icons.my_library_music),
                  title: Text("Songs"),
                  onTap: () {
                    Get.to(SongScreen());
                  },
                ),
                SizedBox(height: 5),
                ListTile(
                  leading: Icon(Icons.tune_rounded),
                  title: Text("Tuner"),
                  onTap: () {
                    Get.to(TunerScreen());
                  },
                ),
              ],
            ),
          ),
          child: ListView(children: [Text("Hello")]),
        ));
  }
}
