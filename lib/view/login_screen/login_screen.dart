// ignore_for_file: prefer_const_constructors, unnecessary_overrides, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/utils/reset_password.dart';
import 'package:gitr/view/admin/admin_login_screen/admin_login_screen.dart';
import 'package:gitr/view/draw_clip/draw_clip.dart';
import 'package:gitr/view/home_screen/home_screen.dart';
import 'package:gitr/view/register_screen/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  @override
  void initState() {
    _controller = AnimationController(
        value: 0.0,
        duration: Duration(seconds: 8),
        upperBound: 1,
        lowerBound: -1,
        vsync: this)
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge([_controller]),
                    builder: (context, child) {
                      return ClipPath(
                        clipper: DrawClip(_controller.value),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height * 0.43,
                          decoration:
                              BoxDecoration(color: ColorConstants.amber),
                          child: Lottie.asset(
                            "assets/animations/Animation-2.json",
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text("Admin"),
                          onTap: () {
                            Get.to(() => AdminLoginScreen());
                            emailcontroller.clear();
                            passcontroller.clear();
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                      controller: emailcontroller,
                      cursorColor: ColorConstants.amber,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_rounded,
                              size: 18,
                              color:
                                  ColorConstants.primaryBlack.withOpacity(0.5)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Colors.amber.shade800),
                              borderRadius: BorderRadius.circular(20)),
                          hintText: "Email"),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: passcontroller,
                      obscureText: true,
                      cursorColor: ColorConstants.amber,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock,
                            size: 18,
                            color:
                                ColorConstants.primaryBlack.withOpacity(0.5)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: Colors.amber.shade800),
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "Password",
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.to(() => ResetPassword());
                              emailcontroller.clear();
                              passcontroller.clear();
                            },
                            child: Text("Forgot Password?")),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          loginUser();
                        },
                        child: Text("LOGIN")),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Don't have an account?"),
                        SizedBox(width: 8),
                        TextButton(
                            onPressed: () {
                              Get.to(() => RegisterScreen());
                              emailcontroller.clear();
                              passcontroller.clear();
                            },
                            child: Text("Register here"))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    String email = emailcontroller.text.trim();
    String pass = passcontroller.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "Please fill in all fields",
            backgroundColor: ColorConstants.red,
          ));
    }
    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Logging In",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            CircularProgressIndicator(color: ColorConstants.amber),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    await Future.delayed(Duration(seconds: 4));
    await FirebaseFunctions()
        .signInUser(email: email, pass: pass)
        .then((response) {
      Get.back();
      if (response == null) {
        Get.offAll(() => GitRHomeScreen());
        print("Login Successful");
        emailcontroller.clear();
        passcontroller.clear();
      } else {
        showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: "Error : $response",
              backgroundColor: ColorConstants.red,
            ));
      }
    });
  }
}
