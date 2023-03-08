import 'package:camera/camera.dart';
import 'package:floraprobe/src/ui/components/dialogs/loading_dialog.dart';
import 'package:floraprobe/src/ui/components/dialogs/result_dialog.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart'
    show BuildContext, Scaffold, ScaffoldMessenger, SnackBar, Text;
import 'package:provider/provider.dart';

import 'scanner.dart';

class CameraViewNotifier with ChangeNotifier {
  double? _aspectRatio = 2 / 3;
  double get aspectRatio => _aspectRatio ?? 2 / 3;

  CameraController? _cameraController;

  CameraController? get cameraController => _cameraController;

  final Loading loading = Loading();

  final ResultsDialog resultDialog = ResultsDialog();

  void setCameraController(CameraController cameraController) {
    _cameraController = cameraController;
    if (setAspectRatio(_cameraController?.value.aspectRatio)) return;
    notifyListeners();
  }

  bool isCameraInitialized() {
    if (_cameraController == null) {
      return false;
    }
    return _cameraController?.value.isInitialized ?? false;
  }

  bool setAspectRatio(double? aspectRatio) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loading camera..'),
        ),
      );
      return;
    }
    deafScannerProvider.setViewState(ScannerState.initializing);
    loading.show(context);
    List? res;
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Attempt to take a picture and log where it's been saved.
      final picture = await cameraController?.takePicture();
      if (picture != null) {
        res = await deafScannerProvider.scanImage(picture, context);
      } else {
        res = [];
      }
      loading.hide();
      // Showing results in dialog
      await resultDialog.show(res ?? const [], context);
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }

    // Resume camera preview
    deafScannerProvider.setViewState(ScannerState.ready);
  }
}
