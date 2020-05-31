import 'package:flutter/widgets.dart';

/// Image provider as Assets of images which might be
/// used in this application
class AppImageAssets {
  static const AssetImage flowerBackground =
      const AssetImage('assets/images/Flora_bg.png');
  static const AssetImage flowerIcon =
      const AssetImage('assets/images/flower.png');
  static const AssetImage foundNothing =
      const AssetImage('assets/images/nothing.png');

  /// Preloads images before they are used in the app
  static void heatImages(BuildContext context) {
    precacheImage(flowerBackground, context);
    precacheImage(flowerIcon, context);
    precacheImage(foundNothing, context);
  }
}

/// String path of models which will be used in application
class ModelAssetPath {
  /// The main model which is used in tensor flow lite
  static const flower_model = 'assets/models/flower_model_v1.tflite';

  /// The labels used in [flower_model]
  static const flower_labels = 'assets/models/label_flowers.txt';
}
