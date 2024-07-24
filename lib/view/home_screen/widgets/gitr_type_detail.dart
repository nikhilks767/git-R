// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/model/type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class GitRTypeScreen extends StatefulWidget {
  const GitRTypeScreen({super.key});

  @override
  State<GitRTypeScreen> createState() => _GitRTypeScreenState();
}

class _GitRTypeScreenState extends State<GitRTypeScreen> {
  List<TypeModel> gitrType = [];
  bool isLoading = true;

  Future<void> loadGitrTypes() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("gitrType").get();
    List<TypeModel> loadedType = [];
    for (var doc in querySnapshot.docs) {
      TypeModel? typeModel = await FirebaseFunctions().getGitrTypes(doc.id);
      if (typeModel != null) {
        loadedType.add(typeModel);
      }
    }
    setState(() {
      gitrType = loadedType;
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    loadGitrTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map;
    final index = arguments['index'] as int;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorConstants.transparent,
          surfaceTintColor: ColorConstants.transparent,
          title: index < gitrType.length
              ? Text(
                  gitrType[index].id == "acoustic"
                      ? "Acoustic Guitar"
                      : gitrType[index].id == "base"
                          ? "Bass Guitar"
                          : gitrType[index].id == "electric"
                              ? "Electric Guitar"
                              : "",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                )
              : SizedBox()),
      body: isLoading
          ? Center(
              child: Lottie.asset("assets/animations/Animation - gitr.json",
                  height: 150),
            )
          : index < gitrType.length
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(gitrType[index].history,
                            textAlign: TextAlign.justify),
                        SizedBox(height: 15),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(gitrType[index].image)),
                        SizedBox(height: 30),
                        Text("Different Types",
                            style: GoogleFonts.poppins(
                                color: ColorConstants.teal, fontSize: 23)),
                        Divider(),
                        SizedBox(height: 10),
                        Text(
                          gitrType[index].id == "acoustic"
                              ? "Dreadnought"
                              : gitrType[index].id == "base"
                                  ? "Electric Bass"
                                  : gitrType[index].id == "electric"
                                      ? "Solid Body Electric Guitar"
                                      : "",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              gitrType[index].img1,
                            )),
                        SizedBox(height: 15),
                        Text(gitrType[index].type1,
                            textAlign: TextAlign.justify),
                        SizedBox(height: 15),
                        Text(
                          gitrType[index].id == "acoustic"
                              ? "Grand Concert"
                              : gitrType[index].id == "base"
                                  ? "Acoustic Bass"
                                  : gitrType[index].id == "electric"
                                      ? "Semi Acoustic Guitar"
                                      : "",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              gitrType[index].img2,
                            )),
                        SizedBox(height: 15),
                        Text(gitrType[index].type2,
                            textAlign: TextAlign.justify),
                        SizedBox(height: 15),
                        Text(
                          gitrType[index].id == "acoustic"
                              ? "Grand Auditorium"
                              : gitrType[index].id == "base"
                                  ? "Hollow Body Bass Guitar"
                                  : "",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              gitrType[index].img3,
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox();
                              },
                            )),
                        SizedBox(
                            height: gitrType[index].id == "electric" ? 0 : 15),
                        Text(gitrType[index].type3,
                            textAlign: TextAlign.justify),
                      ],
                    ),
                  ),
                )
              : Center(child: Text("No data available for this type")),
    );
  }
}
