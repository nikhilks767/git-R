// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/view/admin/admin_home_screen/screens/add_song_screen.dart';
import 'package:gitr/view/admin/admin_home_screen/screens/users_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Dashboard"),
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
            ],
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => UsersListScreen());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color:
                                  ColorConstants.primaryBlack.withOpacity(0.4),
                              spreadRadius: BorderSide.strokeAlignOutside,
                              blurRadius: BorderSide.strokeAlignOutside)
                        ],
                        color: ColorConstants.primaryWhite,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.group_rounded,
                          size: 100,
                          color: ColorConstants.amber,
                          shadows: [
                            Shadow(
                                color: ColorConstants.primaryBlack,
                                blurRadius: 2)
                          ],
                        ),
                        Text(
                          "Users",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => AddSongScreen());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color:
                                  ColorConstants.primaryBlack.withOpacity(0.4),
                              spreadRadius: BorderSide.strokeAlignOutside,
                              blurRadius: BorderSide.strokeAlignOutside)
                        ],
                        color: ColorConstants.primaryWhite,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.library_music_rounded,
                          size: 100,
                          color: ColorConstants.amber,
                          shadows: [
                            Shadow(
                                color: ColorConstants.primaryBlack,
                                blurRadius: 2)
                          ],
                        ),
                        Text(
                          "Add Songs",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
