// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GuitarType extends StatelessWidget {
  const GuitarType({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> gitRType = ["Acoustic", "Electric", "Base"];
    return SizedBox(
      height: 170,
      child: ListView.separated(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(child: Text("🎸")),
            ),
            SizedBox(height: 3),
            Text(gitRType[index],
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16))
          ],
        ),
        separatorBuilder: (context, index) => SizedBox(width: 20),
      ),
    );
  }
}
