import 'package:tflite/tflite.dart';

import '../commons/assets.dart';

/// Responsible for identifying flora in image using the model
class Probe {
  String? _res;
  bool _loaded = false;

  /// Responsible for identifying flora in image using the model
  Probe();
  Future<void> load() async {
    if (_loaded) return;
    // Loades our Tflite model
    _res = await Tflite.loadModel(
        model: ModelAssetPath.flowerModel,
        labels: ModelAssetPath.flowerLabels,
        numThreads: 2, // defaults to 1
        isAsset:
            true // defaults to true, set to false to load resources outside assets
        );
    print('$_res in loading model');
    _loaded = true;
  }

  void dispose() async {
    await Tflite.close();
  }

  /// Runs model from image on `filepath`.
  /// Sample output
  /// ```json
  /// [{
  ///   index: 0,
  ///   label: "flower",
  ///   confidence: 0.629
  /// }]
  /// ```
  Future<List<dynamic>?> runModelFrom(String filepath) async {
    await load();
    var recognitions = await Tflite.runModelOnImage(
      path: filepath, // required
      imageMean: 0.0, // defaults to 117.0
      imageStd: 255.0, // defaults to 1.0
      numResults: 1, // defaults to 5
      threshold: 0.5, // defaults to 0.1
    );
    return recognitions;
  }
}
