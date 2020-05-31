import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/ui/components/dialog.dart';
import 'package:floraprobe/src/utils/probe.dart';
import 'package:flutter/widgets.dart';

enum ScanState { idle, running, completed }

class HomeProvider extends ChangeNotifier {
  CameraDescription _firstCamera;
  Uint8List _bytesOfLatestSnappedImage;
  ImageProvider _latestSnappedImage;
  String _pathOfLatestSnappedImage;

  ImageProvider get latestSnappedImage => _latestSnappedImage;
  String get pathOfLatestSnappedImage => _pathOfLatestSnappedImage;
  Uint8List get bytesOfLatestSnappedImage => _bytesOfLatestSnappedImage;

  ScanState _state = ScanState.idle;

  ScanState get state => _state;
  double _aspectRatio = 16 / 9;

  double get aspectRatio => _aspectRatio ?? 16 / 9;

  setAspectRatio(double aspectRatio) {
    _aspectRatio = aspectRatio;
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
    setAspectRatio(controller?.value?.aspectRatio);
    try {
      final File _imageFile = File(imagePath);
      _bytesOfLatestSnappedImage = _imageFile.readAsBytesSync();
      _latestSnappedImage = FileImage(
        _imageFile,
      );
      await precacheImage(_latestSnappedImage, context);
      setScanState(ScanState.running);
    } catch (e) {
      print(e);
      // Dismissing dialog on error
      loading.dismiss();
      setScanState(ScanState.idle);
      return null;
    }
    notifyListeners();
    // Runs Model
    List results = await Probe().runOnImage(imagePath);
    // setScanState(ScanState.completed); // TODO: always show preview before idle. hint => Stay completed
    loading.dismiss();
    setScanState(ScanState.idle);
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
