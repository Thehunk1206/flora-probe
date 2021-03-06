import 'dart:io' as io;

import 'package:flutter/widgets.dart';

import 'probe.dart';

enum ScannerState {
  /// ready to capture image to run scan on
  ready,

  /// Initializing scan
  initializing,

  /// Running ML model on image
  running,

  /// Scan completed
  completed,
}

class Scanner with ChangeNotifier {
  ScannerState _viewState = ScannerState.ready;

  ScannerState get state => _viewState;

  ImageProvider _latestSnappedImage;

  ImageProvider get latestSnappedImage => _latestSnappedImage;

  final Probe probe;

  Scanner(this.probe);

  Future<void> setLatestSnappedImage(
      BuildContext context, ImageProvider image) async {
    _latestSnappedImage = image;
    await precacheImage(_latestSnappedImage, context);
  }

  void setViewState(ScannerState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  @override
  void dispose() {
    probe.dispose();
    super.dispose();
  }

// Dont forget to hide loading dialog
  Future<List<dynamic>> scanImage(
      String imagePath, BuildContext context) async {
    // Starting theatrics
    try {
      final io.File _imageFile = io.File(imagePath);
      await setLatestSnappedImage(
        context,
        FileImage(
          _imageFile,
        ),
      );
      setViewState(ScannerState.running);
    } catch (e) {
      print(e);
      // Dismissing dialog on error
      setViewState(ScannerState.ready);
      return null;
    }

    // Runs Model
    List results = await probe.runModelFrom(imagePath);
    setViewState(ScannerState.completed);
    return results;
  }
}
