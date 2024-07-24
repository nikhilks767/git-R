// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class LyricPage extends StatefulWidget {
  final String lyrics;
  final String songName;
  const LyricPage({super.key, required this.lyrics, required this.songName});

  @override
  State<LyricPage> createState() => _LyricPageState();
}

class _LyricPageState extends State<LyricPage> {
  final ScrollController _scrollController = ScrollController();
  bool isScroll = false;
  int speedFactor = 10;

  void scrollText() {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: durationDouble.toInt()),
        curve: Curves.linear);
  }

  void toggleScroll() {
    setState(() {
      isScroll = !isScroll;
    });
    if (isScroll) {
      scrollText();
    } else {
      _scrollController.animateTo(_scrollController.offset,
          duration: Duration(seconds: 1), curve: Curves.linear);
    }
  }

  void onScroll() {
    if (_scrollController.position.atEdge && isScroll) {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Future.delayed(Duration(seconds: 1), () {
          if (isScroll) {
            _scrollController.jumpTo(0);
            scrollText();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstants.transparent,
        title: Text(
          widget.songName,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: ColorConstants.deepOrange),
        ),
        actions: [
          Container(
            width: 80,
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isScroll ? ColorConstants.red : ColorConstants.teal),
            child: TextButton(
                style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                onPressed: () {
                  _scrollController.addListener(onScroll);
                  toggleScroll();
                },
                child: isScroll
                    ? Text(
                        "Stop",
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        "Scroll",
                        style: TextStyle(color: Colors.white),
                      )),
          ),
          SizedBox(width: 15)
        ],
      ),
      body: NotificationListener(
        onNotification: (notify) {
          if (notify is ScrollEndNotification && isScroll) {
            Timer(Duration(seconds: 1), () {
              scrollText();
            });
          }
          return true;
        },
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                  width: double.infinity,
                  child: Text(
                    widget.lyrics,
                    style: GoogleFonts.baloo2(fontSize: 18),
                  )),
            )),
      ),
    );
  }
}
