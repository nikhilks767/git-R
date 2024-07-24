// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleChords extends StatelessWidget {
  const SimpleChords({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            sheetAnimationStyle:
                AnimationStyle(duration: Duration(milliseconds: 950)),
            context: context,
            builder: (context) {
              return BottomSheet(
                  enableDrag: false,
                  onClosing: () {
                    Get.back();
                  },
                  builder: (context) => Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        child: Image.asset("assets/images/chords.jpg",
                            fit: BoxFit.fill),
                      )));
            },
          );
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: AssetImage("assets/images/simple_chord.jpg"),
                      fit: BoxFit.fill)),
            ),
            Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                  color: ColorConstants.primaryBlack.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text("Simple Chords",
                    style: GoogleFonts.poppins(
                        color: ColorConstants.primaryWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
