// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/model/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  var usersList = <UserModel>[].obs;
  bool isLoading = true;

  Future<void> loadUsers() async {
    List<UserModel> allUsers = await FirebaseFunctions.getAllUsers();
    usersList.addAll(allUsers);
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Lottie.asset("assets/animations/Animation - gitr.json",
                  height: 150),
            )
          : Obx(() {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.separated(
                  itemCount: usersList.length,
                  itemBuilder: (context, index) {
                    var user = usersList[index];
                    return Card(
                      surfaceTintColor: ColorConstants.teal,
                      child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Name  : ${user.name}",
                                    style: GoogleFonts.poppins()),
                                SizedBox(height: 8),
                                Text("Email   : ${user.email}",
                                    style: GoogleFonts.poppins()),
                                SizedBox(height: 8),
                                Text("Phone : ${user.phone}",
                                    style: GoogleFonts.poppins()),
                              ],
                            ),
                          )),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                ),
              );
            }),
    );
  }
}
