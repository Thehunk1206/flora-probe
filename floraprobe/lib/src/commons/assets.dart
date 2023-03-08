import 'package:floraprobe/src/ui/components/decorations/scannerSVG.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transparent_image/transparent_image.dart';

/// Image provider as Assets of images which might be
/// used in this application
class AppImageAssets {
  static const AssetImage flowerBackground =
      AssetImage('assets/images/Flora_bg.png');
  static const AssetImage flowerIcon = AssetImage('assets/images/flower.png');
  static const AssetImage foundNothing =
      AssetImage('assets/images/nothing.png');
  static MemoryImage transparentImage = MemoryImage(kTransparentImage);
  static SvgPicture scannerVector = SvgPicture.string(
    scannerSVG,
    allowDrawingOutsideViewBox: true,
  );

  /// Preloads images before they are used in the app
  static Future<void> cacheMedia(BuildContext context) async {
    await precacheImage(flowerBackground, context);
    await precacheImage(flowerIcon, context);
    await precacheImage(foundNothing, context);
    await precacheImage(transparentImage, context);
  }
}

/// String path of models which will be used in application
class ModelAssetPath {
  /// The main model which is used in tensor flow lite
  static const flower_model = 'assets/models/flower_model_v1.tflite';

  /// The labels used in [flower_model]
  static const flower_labels = 'assets/models/label_flowers.txt';
}
