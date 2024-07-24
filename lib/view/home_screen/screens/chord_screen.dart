// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_guitar_chord/flutter_guitar_chord.dart';
import 'package:gitr/constants/color_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guitar_chord_library/guitar_chord_library.dart';

class ChordScreen extends StatefulWidget {
  const ChordScreen({super.key});

  @override
  State<ChordScreen> createState() => _ChordScreenState();
}

class _ChordScreenState extends State<ChordScreen> {
  final List<String> instrumentList = ["Guitar"];
  String? selection;
  bool isFlat = true;

  @override
  Widget build(BuildContext context) {
    var instrument = (selection == null || selection == "Guitar")
        ? GuitarChordLibrary.instrument(InstrumentType.guitar)
        : GuitarChordLibrary.instrument(InstrumentType.ukulele);
    var keys = instrument.getKeys(isFlat);
    return DefaultTabController(
      length: keys.length,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            automaticallyImplyLeading: false,
            titleSpacing: 5,
            title: Text(instrumentList.join(),
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            actions: [
              Row(
                children: [
                  Text("Flat Note"),
                  Switch(
                    activeColor: ColorConstants.amber,
                    splashRadius: 20,
                    value: isFlat,
                    onChanged: (value) {
                      setState(() {
                        isFlat = value;
                      });
                    },
                  )
                ],
              ),
              SizedBox(width: 25)
            ],
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.sizeOf(context).width, 60),
              child: TabBar(
                  tabAlignment: TabAlignment.start,
                  indicator: BoxDecoration(
                    color: ColorConstants.amber,
                  ),
                  labelStyle: GoogleFonts.rubik(),
                  labelColor: ColorConstants.primaryWhite,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 25,
                  ),
                  isScrollable: true,
                  tabs: keys.map((e) {
                    return Tab(text: e);
                  }).toList()),
            ),
          ),
          body: TabBarView(
              children: keys.map((e) {
            var chords = instrument.getChordsByKey(e, isFlat);

            return GridView.builder(
              itemCount: chords!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 15,
                top: 30,
              ),
              itemBuilder: (context, index) {
                var chord = chords[index];
                var position = chord.chordPositions[0];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FlutterGuitarChord(
                    fingers: position.fingers,
                    frets: position.frets,
                    baseFret: position.baseFret,
                    chordName: chord.name,
                    totalString: instrument.stringCount,
                  ),
                );
              },
            );
          }).toList())),
    );
  }
}
