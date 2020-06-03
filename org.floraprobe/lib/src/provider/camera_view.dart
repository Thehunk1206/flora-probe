import 'package:camera/camera.dart';
import 'package:floraprobe/src/ui/components/loading_dialog.dart';
import 'package:floraprobe/src/ui/components/result_dialog.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart'
    show Scaffold, SnackBar, Text, BuildContext;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:provider/provider.dart';

import 'scanner.dart';

class CameraViewNotifier with ChangeNotifier {
  double _aspectRatio = 2 / 3;
  double get aspectRatio => _aspectRatio ?? 2 / 3;

  CameraController _cameraController;

  CameraController get cameraController => _cameraController;

  final Loading loading = Loading();

  final ResultsDialog resultDialog = ResultsDialog();

  void setCameraController(CameraController cameraController) {
    _cameraController = cameraController;
    if (setAspectRatio(_cameraController?.value?.aspectRatio)) return;
    notifyListeners();
  }

  bool isCameraInitialized() {
    if (_cameraController == null) {
      return false;
    }
    return _cameraController?.value?.isInitialized ?? false;
  }

  bool setAspectRatio(double aspectRatio) {
    if (_aspectRatio != aspectRatio) {
      _aspectRatio = aspectRatio;
      print("Aspect ratio changed");
      notifyListeners();
      return true;
    }
    return false;
  }

  void captureAndScan(BuildContext context) async {
    Scanner deafScannerProvider = Provider.of<Scanner>(context, listen: false);
    if (deafScannerProvider.state != ScannerState.ready) return;
    if (!isCameraInitialized()) {
      // Shows when not initialized
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Loading camera..'),
        ),
      );
      return;
    }
    deafScannerProvider.setViewState(ScannerState.initializing);
    loading.show(context);
    List<dynamic> res;
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Construct the path where the image should be saved
      // package.
      final String path = p.join(
        // Store the picture in the temp directory.
        (await pp.getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      // Attempt to take a picture and log where it's been saved.
      await cameraController.takePicture(path);
      res = await deafScannerProvider.scanImage(path, context);
      loading.hide();
      // Showing results in dialog
      await resultDialog.show(res, context);
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }

    // Resume camera preview
    deafScannerProvider.setViewState(ScannerState.ready);
  }
}
