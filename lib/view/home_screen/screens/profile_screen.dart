// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/model/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController newnamecontroller = TextEditingController();
  TextEditingController newphonecontroller = TextEditingController();
  String? username;
  String? email;
  int? phone;
  bool isLoading = true;
  @override
  void initState() {
    loadUser();
    super.initState();
  }

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      UserModel? userModel = await FirebaseFunctions().getUserProfile(user.uid);
      setState(() {
        username = userModel!.name;
        email = userModel.email!;
        phone = userModel.phone!;
        isLoading = !isLoading;
      });
    }
  }

  // Future<void> getProfilePicture() async {
  //   final imageBytes = await storage.getFile("nik.jpg");
  //   if (imageBytes == null) return;
  //   setState(() {
  //     pickedImage = imageBytes;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? Center(
              child: Lottie.asset("assets/animations/Animation - gitr.json",
                  height: 150),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstants.amberShade200,
                        ),
                        child: Icon(Icons.person, size: 80),
                      ),
                      Positioned(
                          bottom: 2,
                          right: 60,
                          child: IconButton(
                              onPressed: () async {},
                              icon: Icon(Icons.edit_square, size: 30)))
                    ],
                  ),
                  SizedBox(height: 40),
                  Card(
                    surfaceTintColor: ColorConstants.teal,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      leading: Icon(Icons.person),
                      title: Text("$username".toUpperCase()),
                      trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Edit Your Name",
                                        style: GoogleFonts.poppins()),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      controller: newnamecontroller,
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorConstants.amber,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          hintText: "Enter new name"),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Get.back(result: context);
                                              newnamecontroller.clear();
                                            },
                                            child: Text("Cancel")),
                                        ElevatedButton(
                                            onPressed: () {
                                              updateName();
                                            },
                                            child: Text("Update")),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit, size: 20)),
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    surfaceTintColor: ColorConstants.teal,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      leading: Icon(Icons.email),
                      title: Text("$email"),
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    surfaceTintColor: ColorConstants.teal,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      leading: Icon(Icons.phone),
                      title: Text("$phone"),
                      trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Edit Phone Number",
                                        style: GoogleFonts.poppins()),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      controller: newphonecontroller,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorConstants.amber,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          hintText: "Enter new Phone no."),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Get.back(result: context);
                                              newphonecontroller.clear();
                                            },
                                            child: Text("Cancel")),
                                        ElevatedButton(
                                            onPressed: () {
                                              updatePhone();
                                            },
                                            child: Text("Update")),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit, size: 20)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void updateName() async {
    try {
      String newname = newnamecontroller.text;
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && newname.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({'name': newname});
        Get.back(result: context);
        setState(() {
          username = newname;
        });
      } else {
        showTopSnackBar(Overlay.of(context),
            CustomSnackBar.error(message: "Please fill the field"));
      }
    } catch (e) {
      print("Error : $e");
    }
  }

  void updatePhone() async {
    try {
      String phoneText = newphonecontroller.text;
      if (phoneText.isEmpty) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(message: "Please fill the field"),
        );
        return;
      }

      int newphone = int.parse(newphonecontroller.text);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null &&
          newphonecontroller.text.isNotEmpty &&
          newphonecontroller.text.length == 10) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({'phone': newphone});
        Get.back(result: context);
        setState(() {
          phone = newphone;
          newphonecontroller.clear();
        });
      } else {
        showTopSnackBar(Overlay.of(context),
            CustomSnackBar.error(message: "Invalid Phone number"));
      }
    } catch (e) {
      print("Error : $e");
    }
  }
  // Future<void> onProfileTapped() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image == null) return;
  //   await storage.uploadFile("nik.jpg", image);
  //   final imageBytes = await image.readAsBytes();
  //   setState(() {
  //     pickedImage = imageBytes;
  //   });
  // }
}
