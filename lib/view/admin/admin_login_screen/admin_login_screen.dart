// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/view/admin/admin_home_screen/admin_home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController namecontroller = TextEditingController();
    TextEditingController passcontroller = TextEditingController();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/admin_logo.png", scale: 2),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "LOGIN",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: namecontroller,
                        cursorColor: ColorConstants.amber,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.amber.shade800),
                                borderRadius: BorderRadius.circular(20)),
                            hintText: "Username"),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: passcontroller,
                        obscureText: true,
                        cursorColor: ColorConstants.amber,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Colors.amber.shade800),
                              borderRadius: BorderRadius.circular(20)),
                          hintText: "Password",
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: () {
                            if (namecontroller.text == "admin" &&
                                passcontroller.text == "gitrAdmin") {
                              Get.to(() => AdminHomeScreen());
                              print("Login Successful");
                              namecontroller.clear();
                              passcontroller.clear();
                            } else if (namecontroller.text.isEmpty ||
                                passcontroller.text.isEmpty) {
                              showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                    message: "Please fill out the fields",
                                    backgroundColor: ColorConstants.red,
                                  ));
                            } else {
                              showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                    message:
                                        "Username or Password is incorrect",
                                    backgroundColor: ColorConstants.red,
                                  ));
                            }
                          },
                          child: Text("LOGIN")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
