// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gitr/constants/color_constants.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
                color: ColorConstants.amber,
                borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    );
  }
}
