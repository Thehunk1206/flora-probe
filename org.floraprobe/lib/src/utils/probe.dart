import 'dart:typed_data';

import 'package:tflite/tflite.dart';

import '../commons/assets.dart';

/// Responsible for identifying flora in image using the model
class Probe {
  String _res;

  Future<void> load() async {
    // Loades our Tflite model
    _res = await Tflite.loadModel(
        model: ModelAssetPath.flower_model,
        labels: ModelAssetPath.flower_labels,
        numThreads: 2, // defaults to 1
        isAsset:
            true // defaults to true, set to false to load resources outside assets
        );
    print('$_res in loading model');
  }

  Future<void> dispose() async {
    await Tflite.close();
  }

  /// Runs model on Uint8List.
  /// Sample output
  /// ```json
  /// {
  ///   index: 0,
  ///   label: "person",
  ///   confidence: 0.629
  /// }
  /// ```
  Future<List<dynamic>> run(Uint8List binary) async {
    await load();
    var recognitions = await Tflite.runModelOnBinary(
      binary: binary,
      numResults: 1, // defaults to 5
      threshold: 0.5, // defaults to 0.1
    );
    Tflite.close();
    return recognitions;
  }

  /// Runs model on Uint8List.
  /// Sample output
  /// ```json
  /// {
  ///   index: 0,
  ///   label: "person",
  ///   confidence: 0.629
  /// }
  /// ```
  Future<List<dynamic>> runOnImage(String filepath) async {
    await load();
    var recognitions = await Tflite.runModelOnImage(
      path: filepath, // required
      imageMean: 0.0, // defaults to 117.0
      imageStd: 255.0, // defaults to 1.0
      numResults: 1, // defaults to 5
      threshold: 0.5, // defaults to 0.1
    );
    Tflite.close();
    return recognitions;
  }
}
