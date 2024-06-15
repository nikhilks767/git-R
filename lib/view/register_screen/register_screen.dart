// ignore_for_file: prefer_const_constructors, unnecessary_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/view/drawer/draw_clip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  late CollectionReference _userCollection;
  bool isVisible = true;
  @override
  void initState() {
    _controller = AnimationController(
        value: 0.0,
        duration: Duration(seconds: 8),
        upperBound: 1,
        lowerBound: -1,
        vsync: this)
      ..repeat();
    _userCollection = FirebaseFirestore.instance.collection("users");
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
                            "assets/animations/Animation-3.json",
                          ),
                        ),
                      );
                    },
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
                          "REGISTER",
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
                          hintText: "Name"),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: emailcontroller,
                      cursorColor: ColorConstants.amber,
                      decoration: InputDecoration(
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
                      obscureText: isVisible,
                      cursorColor: ColorConstants.amber,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: Colors.amber.shade800),
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "Password",
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: isVisible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility)),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: phonecontroller,
                      cursorColor: ColorConstants.amber,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Colors.amber.shade800),
                              borderRadius: BorderRadius.circular(20)),
                          hintText: "Phone no."),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                          registerUser();
                        },
                        child: Text("REGISTER")),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Already have an account?"),
                        SizedBox(width: 8),
                        TextButton(
                            onPressed: () {
                              Get.back(result: context);
                            },
                            child: Text("Login here"))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void registerUser() {
    String name = namecontroller.text.trim();
    String email = emailcontroller.text.trim();
    String pass = passcontroller.text.trim();
    int phone = int.parse(phonecontroller.text.trim());

    FirebaseFunctions()
        .signUpUser(email: email, pass: pass, name: name, phone: phone)
        .then((response) {
      if (response == null) {
        Get.back(result: context);
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

  // Future<void> addUser() {
  //   return _userCollection.add({
  //     "name": namecontroller.text,
  //     "email": emailcontroller.text,
  //     "phone": phonecontroller.text,
  //   }).then((value) {
  //     print("User Added Successfully");
  //   }).catchError((error) {
  //     print("Failed: $error");
  //   });
  // }

  // Stream<QuerySnapshot> getUser() {
  //   return _userCollection.snapshots();
  // }
}
