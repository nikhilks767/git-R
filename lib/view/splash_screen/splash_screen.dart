// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/view/home_screen/home_screen.dart';
import 'package:gitr/view/login_screen/login_screen.dart';
// import 'package:lottie/lottie.dart';
// import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    Timer(Duration(seconds: 5), navigateToNextScreen);
  }

  Future<void> navigateToNextScreen() async {
    if (user == null) {
      await Get.off(() => LoginScreen());
    } else {
      await Get.off(() => GitRHomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logon.png",
              height: 400,
              // width: double.infinity,
            ),
            // Text("Where Words Fail ...",
            //     style: GoogleFonts.montez(
            //         textStyle: TextStyle(
            //             fontSize: 30,
            //             fontWeight: FontWeight.bold,
            //             color: ColorConstants.primaryWhite,
            //             shadows: [
            //           Shadow(color: ColorConstants.deepOrange, blurRadius: 3)
            //         ]))),
            // Text("Music Speaks 🎶",
            //     style: GoogleFonts.montez(
            //         textStyle: TextStyle(
            //             fontSize: 30,
            //             fontWeight: FontWeight.bold,
            //             color: ColorConstants.primaryWhite,
            //             shadows: [
            //           Shadow(color: ColorConstants.deepOrange, blurRadius: 3)
            //         ]))),
          ],
        ),
        // child: Stack(
        //   alignment: Alignment.centerLeft,
        //   children: [
        //     // Lottie.asset("assets/animations/Animation - 1717522994108.json"),
        //     Container(
        //         width: double.infinity,
        //         height: MediaQuery.sizeOf(context).height,
        //         child: Image.asset(
        //           "assets/images/gtr_fog.jpg",
        //           fit: BoxFit.cover,
        //         )),
        //     Padding(
        //       padding: const EdgeInsets.only(left: 50),
        //       child: Text("Where Words Fail ...",
        //           style: GoogleFonts.montez(
        //               textStyle: TextStyle(
        //                   fontSize: 30,
        //                   fontWeight: FontWeight.bold,
        //                   color: ColorConstants.primaryWhite,
        //                   shadows: [
        //                 Shadow(color: Colors.black, blurRadius: 5)
        //               ]))),
        //     ),

        //     Padding(
        //       padding: const EdgeInsets.only(left: 140),
        //       child: Text("\n\nMusic Speaks 🎶",
        //           style: GoogleFonts.montez(
        //               textStyle: TextStyle(
        //                   fontSize: 30,
        //                   fontWeight: FontWeight.bold,
        //                   color: ColorConstants.primaryWhite,
        //                   shadows: [
        //                 Shadow(color: ColorConstants.deepOrange, blurRadius: 5)
        //               ]))),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
