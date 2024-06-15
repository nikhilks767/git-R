// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, empty_statements

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/model/user.dart';
import 'package:gitr/view/home_screen/screens/chord_screen.dart';
import 'package:gitr/view/home_screen/screens/profile_screen.dart';
import 'package:gitr/view/home_screen/screens/song_screen.dart';
import 'package:gitr/view/home_screen/screens/tuner_screen.dart';
import 'package:gitr/view/home_screen/widgets/heading.dart';
import 'package:slidable_drawer/slidable_drawer.dart';

class GitRHomeScreen extends StatefulWidget {
  const GitRHomeScreen({super.key});

  @override
  State<GitRHomeScreen> createState() => _GitRHomeScreenState();
}

class _GitRHomeScreenState extends State<GitRHomeScreen> {
  final SlidableDrawerController _slidableDrawerController =
      SlidableDrawerController();
  String userName = "Loading...";
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFunctions firebaseFunctions = FirebaseFunctions();
      UserModel? userModel = await firebaseFunctions.getUserProfile(user.uid);
      if (userModel != null) {
        setState(() {
          userName = userModel.name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.primaryWhite,
        appBar: AppBar(
          backgroundColor: ColorConstants.primaryWhite,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                _slidableDrawerController.animateToOpen();
              },
              icon: Icon(Icons.menu)),
          title: Text("Welcome, $userName"),
        ),
        body: SlidableDrawer(
          innerDrawerController: _slidableDrawerController,
          drawerWidth: MediaQuery.of(context).size.width * 0.6,
          drawerBody: Drawer(
            shape: ContinuousRectangleBorder(),
            surfaceTintColor: ColorConstants.primaryWhite,
            backgroundColor: ColorConstants.primaryWhite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Image.asset(
                        "assets/images/logonround.png",
                        scale: 3.5,
                      ),
                    ),
                    SizedBox(height: 30),
                    ListTile(
                      leading: Icon(Icons.music_note),
                      title: Text("Chords"),
                      onTap: () {
                        Get.to(() => ChordScreen());
                      },
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      leading: Icon(Icons.my_library_music),
                      title: Text("Songs"),
                      onTap: () {
                        Get.to(() => SongScreen());
                      },
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      leading: Icon(Icons.tune_rounded),
                      title: Text("Tuner"),
                      onTap: () {
                        Get.to(() => TunerScreen());
                      },
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Profile"),
                      onTap: () {
                        Get.to(() => ProfileScreen());
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(Icons.logout_rounded),
                    title: Text("Logout"),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        Get.back(result: context);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          child: Column(
            children: [
              Heading(),
            ],
          ),
        ));
  }
}
