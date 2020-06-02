import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/ui/components/loading_dialog.dart';
import 'package:floraprobe/src/utils/probe.dart';
import 'package:flutter/widgets.dart';

enum ScanState {
  ready,
  initializing,
  running,
  completed,
}

class HomeProvider extends ChangeNotifier {
  CameraDescription _firstCamera;
  ImageProvider _latestSnappedImage;
  String _pathOfLatestSnappedImage;

  ImageProvider get latestSnappedImage => _latestSnappedImage;
  String get pathOfLatestSnappedImage => _pathOfLatestSnappedImage;

  ScanState _state = ScanState.ready;

  ScanState get state => _state;
  double _aspectRatio = 2 / 3;

  double get aspectRatio => _aspectRatio ?? 2 / 3;

  setAspectRatio(double aspectRatio) {
    if (_aspectRatio != aspectRatio) {
      _aspectRatio = aspectRatio;
      print("Aspect ratio changed");
      notifyListeners();
    }
  }

  /// Set scan state
  void setScanState(ScanState scanstate) {
    _state = scanstate;
    notifyListeners();
  }

  Future<List<dynamic>> searchImage(
      String imagePath,
      CameraController controller,
      BuildContext context,
      Loading loading) async {
    // Starting theatrics
    try {
      final File _imageFile = File(imagePath);
      _latestSnappedImage = FileImage(
        _imageFile,
      );
      await precacheImage(_latestSnappedImage, context);
      setScanState(ScanState.running);
    } catch (e) {
      print(e);
      // Dismissing dialog on error
      loading.hide();
      setScanState(ScanState.ready);
      return null;
    }

    // Runs Model
    List results = await Probe().runOnImage(imagePath);
    loading.hide();
    setScanState(ScanState
        .completed); // TODO: always show preview before idle. hint => Stay completed
    return results;
  }

  HomeProvider(BuildContext context) {
    init(context);
  }

  Future<CameraDescription> acquireCamera() async {
    try {
      // Obtain a list of the available cameras on the device.
      final cameras = await availableCameras();
      // Get a specific camera from the list of available cameras.
      _firstCamera = cameras.first;
      return _firstCamera;
    } on CameraException {
      print('[CameraException] Couldn\'t acquire camera');
      return null;
    }
  }

  void init(BuildContext context) async {
    AppImageAssets.heatImages(context);
  }
}
