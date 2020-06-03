import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/commons/routing_const.dart';
import 'package:floraprobe/src/commons/styles.dart';
import 'package:floraprobe/src/provider/camera_view.dart';
import 'package:floraprobe/src/provider/scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:provider/provider.dart';

import 'CameraView2.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Scanner scannerProvider = Provider.of<Scanner>(context);
    final bool _shouldShowCamera =
        (scannerProvider.state == ScannerState.ready ||
            scannerProvider.state == ScannerState.initializing);
    // If Scanner.state is ScannerState.ready then this child will be a live camera preview
    // else this viewportChild will be the latest snapshot took from camera.
    Widget viewportChild = Stack(
      children: [
        Visibility(
          visible: _shouldShowCamera,
          maintainState: true,
          child: CameraView(
            key: CameraViewKey,
          ),
        ),
        Visibility(
          visible: !_shouldShowCamera,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: Corners.borderRadius,
              image: DecorationImage(
                image: scannerProvider?.latestSnappedImage ??
                    AppImageAssets.transparentImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );

    // This is the widget onto which the `viewportChild` will be shown
    return Center(
      child: Padding(
        padding: Paddings.padding8,
        child: Bounce(
          onPressed: () =>
              Provider.of<CameraViewNotifier>(context, listen: false)
                  .captureAndScan(context),
          duration: const Duration(milliseconds: 120),
          child: Card(
            elevation: 20,
            // To avoid weird shadow when the camera preview hasn't been displayed
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: Corners.borderRadius,
            ),
            child: Consumer<CameraViewNotifier>(
              builder: (context, cameraView, _) {
                return AspectRatio(
                  // Changes the aspectRatio of this widget as same as CameraView.
                  // The aspectRatio used here is obtained from CameraController used in CameraView widget.
                  // When that aspectRatio is null, 2/3 is used as a fallback.
                  aspectRatio: cameraView?.aspectRatio ?? 2 / 3,
                  child: viewportChild,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
