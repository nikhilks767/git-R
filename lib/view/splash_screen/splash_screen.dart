// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/view/admin/admin_home_screen/admin_home_screen.dart';
import 'package:gitr/view/home_screen/home_screen.dart';
import 'package:gitr/view/login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user;
  final String adminEmail = "admin@gmail.com";
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
      if (user!.email == adminEmail) {
        await Get.off(() => AdminHomeScreen());
      } else {
        await Get.off(() => GitRHomeScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryBlack,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/gtr_fog.jpg"),
                    fit: BoxFit.cover)),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: ColorConstants.primaryBlack.withOpacity(0.6),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logon_bg.png",
                  height: 300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
