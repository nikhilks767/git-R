// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, empty_statements, sized_box_for_whitespace, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/model/user.dart';
import 'package:gitr/view/home_screen/screens/chord_screen.dart';
import 'package:gitr/view/home_screen/screens/profile_screen.dart';
import 'package:gitr/view/home_screen/screens/song_screen.dart';
import 'package:gitr/view/home_screen/screens/support_screen.dart';
import 'package:gitr/view/home_screen/screens/tuner_screen.dart';
import 'package:gitr/view/home_screen/widgets/carousel_slider.dart';
import 'package:gitr/view/home_screen/widgets/guitar_type.dart';
import 'package:gitr/view/home_screen/widgets/simple_chords.dart';
import 'package:gitr/view/login_screen/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:slidable_drawer/slidable_drawer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class GitRHomeScreen extends StatefulWidget {
  const GitRHomeScreen({super.key});

  @override
  State<GitRHomeScreen> createState() => _GitRHomeScreenState();
}

class _GitRHomeScreenState extends State<GitRHomeScreen> {
  final SlidableDrawerController _slidableDrawerController =
      SlidableDrawerController();
  String userName = "";
  bool isPressed = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      isLoading = true;
    });
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFunctions firebaseFunctions = FirebaseFunctions();
      UserModel? userModel = await firebaseFunctions.getUserProfile(user.uid);
      if (userModel != null) {
        setState(() {
          userName = userModel.name;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() {
    return Future.delayed(
      Duration(seconds: 1),
      () async {
        await _loadUserProfile();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryWhite,
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryWhite,
        automaticallyImplyLeading: false,
        surfaceTintColor: ColorConstants.transparent,
        leading: IconButton(
          onPressed: () {
            isPressed
                ? _slidableDrawerController.animateToClose()
                : _slidableDrawerController.animateToOpen();
            setState(() {
              isPressed = !isPressed;
            });
          },
          icon: Icon(Icons.menu),
        ),
        title: Row(
          children: [
            Text(
              "Welcome,",
              style:
                  GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(width: 5),
            isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child:
                        CircularProgressIndicator(color: ColorConstants.amber),
                  )
                : Text(
                    userName,
                    style: GoogleFonts.abel(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SlidableDrawer(
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
                      leading: Icon(Icons.support_agent_rounded),
                      title: Text("Support"),
                      onTap: () {
                        Get.to(() => SupportScreen());
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
                    onTap: () {
                      logoutUser();
                    },
                  ),
                ),
              ],
            ),
          ),
          child: isLoading
              ? Center(
                  child: Lottie.asset("assets/animations/Animation - gitr.json",
                      height: 150),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Carousel(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 50),
                            child: Text(
                              "Types of Guitar",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                          ),
                          SizedBox(height: 15),
                          GuitarType(),
                          SizedBox(height: 30),
                          SimpleChords(),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void logoutUser() async {
    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Logging Out",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            CircularProgressIndicator(color: ColorConstants.amber),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    await Future.delayed(Duration(seconds: 4));
    await FirebaseFunctions.signOutUser().then((response) {
      Get.back();
      if (response == null) {
        Get.offAll(() => LoginScreen());
        print("Logged out Successfully");
      } else {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(message: "Error: $response"),
        );
      }
    });
  }
}
