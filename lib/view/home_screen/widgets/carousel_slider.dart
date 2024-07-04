// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  Carousel({super.key});

  final List imageList = [
    "assets/images/guitar1.jpg",
    "assets/images/guitar2.jpg",
    "assets/images/learn_guitar.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: imageList.length,
        itemBuilder: (context, index, realIndex) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imageList[index]), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
        options: CarouselOptions(
            height: 250,
            autoPlayAnimationDuration: Duration(seconds: 1),
            autoPlay: true,
            enlargeCenterPage: true));
  }
}
