// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  StreamSubscription<List<int>>? _micStreamSubscription;
  final List<double> _audioBuffer = [];
  double _detectedFrequency = 0.0;
  String _closestNote = '';
  double _closestFrequency = 0.0;
  final List<Map<String, double>> _standardTuning = [
    {'string': 6, 'note': 82.41}, // E2
    {'string': 5, 'note': 110.00}, // A2
    {'string': 4, 'note': 146.83}, // D3
    {'string': 3, 'note': 196.00}, // G3
    {'string': 2, 'note': 246.94}, // B3
    {'string': 1, 'note': 329.63}, // E4
  ];

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      await _recorder.openAudioSession();
      setState(() {
        _isRecording = true;
      });
      _startRecording();
    } else {
      showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
              message: "Microphone Permission is required"));
    }
  }

  void _startRecording() {
    _micStreamSubscription =
        MicStream.microphone(sampleRate: 44100).listen((data) {
      final buffer = data.map((e) => e.toDouble()).toList();
      setState(() {
        _audioBuffer.addAll(buffer);
        if (_audioBuffer.length >= 2048) {
          _analyzeAudio();
          _audioBuffer.clear();
        }
      });
    });
  }

  Future<void> _analyzeAudio() async {
    // Ensure the buffer is a list of doubles
    final buffer = _audioBuffer.map((e) => e.toDouble()).toList();
    final pitchDetector =
        PitchDetector(audioSampleRate: 44100, bufferSize: 2048);
    final result = await pitchDetector.getPitchFromFloatBuffer(buffer);
    if (result.pitched) {
      final detectedFrequency = result.pitch;

      // Find the closest note
      final closestNoteData = _standardTuning.reduce((prev, curr) {
        return (curr['note']! - detectedFrequency).abs() <
                (prev['note']! - detectedFrequency).abs()
            ? curr
            : prev;
      });

      setState(() {
        _detectedFrequency = detectedFrequency;
        _closestNote = 'String ${closestNoteData['string']}';
        _closestFrequency = closestNoteData['note']!;
      });
    }
  }

  @override
  void dispose() {
    _micStreamSubscription?.cancel();
    _recorder.closeAudioSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Guitar Tuner',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Detected Frequency: ${_detectedFrequency.toStringAsFixed(2)} Hz',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            Text(
              'Closest Note: $_closestNote (${_closestFrequency.toStringAsFixed(2)} Hz)',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 50),
            _isRecording
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _initializeRecorder,
                    child: const Text('Start Tuning'),
                  ),
          ],
        ),
      ),
    );
  }
}
