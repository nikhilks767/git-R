// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:gitr/view/home_screen/widgets/gitr_type_detail.dart';
import 'package:google_fonts/google_fonts.dart';

class GuitarType extends StatelessWidget {
  const GuitarType({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> gitRType = ["Acoustic", "Bass", "Electric"];
    List images = [
      "assets/images/acoustic.jpg",
      "assets/images/base.jpg",
      "assets/images/electric.jpg",
    ];
    return SizedBox(
      height: 170,
      child: ListView.separated(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Get.to(() => GitRTypeScreen(), arguments: {'index': index});
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width / 3,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorConstants.teal),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                  )),
              SizedBox(height: 3),
              Text(gitRType[index],
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16))
            ],
          ),
        ),
        separatorBuilder: (context, index) => SizedBox(width: 20),
      ),
    );
  }
}
