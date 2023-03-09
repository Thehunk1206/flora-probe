import 'package:camera/camera.dart';
import 'package:floraprobe/src/controllers/scanner.dart';
import 'package:floraprobe/src/ui/components/dialogs/loading_dialog.dart';
import 'package:floraprobe/src/ui/components/dialogs/result_dialog.dart';
import 'package:flutter/material.dart'
    show BuildContext, ScaffoldMessenger, SnackBar, Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/scanner.dart';

class CameraViewController extends StateNotifier<CameraController?> {
  final Ref _ref;

  CameraViewController(this._ref) : super(null);

  Scanner get _scanner => _ref.read(scannerProvider.notifier);

  final Loading loading = Loading();

  final ResultsDialog resultDialog = ResultsDialog();

  void setCameraController(CameraController cameraController) {
    state = cameraController;
  }

  void captureAndScan(BuildContext context) async {
    final Scanner scanner = _scanner;
    if (scanner.state.step != ScannerStateStep.ready) return;
    final ctrl = state;
    if (ctrl == null || !ctrl.value.isInitialized) {
      // Shows when not initialized
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loading camera..'),
        ),
      );
      return;
    }
    scanner.updateStep(ScannerStateStep.initializing);
    loading.show(context);
    List? res;
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Attempt to take a picture and log where it's been saved.
      final picture = await ctrl.takePicture();
      res = await scanner.scanImage(picture, context);

      loading.hide();
      // Showing results in dialog
      await resultDialog.show(res ?? const [], context);
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }

    // Resume camera preview
    scanner.updateStep(ScannerStateStep.ready);
  }
}
