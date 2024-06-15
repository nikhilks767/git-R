// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class Heading extends StatelessWidget {
  const Heading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 20, left: MediaQuery.sizeOf(context).width * 0.2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Where Words",
                style: GoogleFonts.montez(
                    textStyle: TextStyle(
                        color: ColorConstants.primaryBlack.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
              ),
              SizedBox(width: 8),
              Text(
                "Fail...",
                style: GoogleFonts.montez(
                    textStyle: TextStyle(
                        color: ColorConstants.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 50)),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.35),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Music",
                style: GoogleFonts.montez(
                    textStyle: TextStyle(
                        color: ColorConstants.primaryWhite,
                        shadows: [
                          Shadow(color: ColorConstants.red, blurRadius: 5)
                        ],
                        fontWeight: FontWeight.bold,
                        fontSize: 50)),
              ),
              SizedBox(width: 10),
              Text(
                "Speaks 🎶",
                style: GoogleFonts.montez(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: ColorConstants.primaryBlack.withOpacity(0.7))),
              ),
            ],
          ),
        )
      ],
    );
  }
}
