import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/commons/routing_const.dart';
import 'package:floraprobe/src/commons/styles.dart';
import 'package:floraprobe/src/controllers/scanner.dart';
import 'package:floraprobe/src/provider/camera_view.dart';
import 'package:floraprobe/src/provider/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'camera_view.dart';

class ScannerView extends ConsumerWidget {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowCamera = ref.watch(scannerProvider.select((value) =>
        value.step == ScannerStateStep.ready ||
        value.step == ScannerStateStep.initializing));
    final latestSnappedImage =
        ref.watch(scannerProvider.select((value) => value.latestSnappedImage));
    // If Scanner.state is ScannerState.ready then this child will be a live camera preview
    // else this viewportChild will be the latest snapshot took from camera.
    Widget viewportChild = Stack(
      children: [
        Visibility(
          visible: shouldShowCamera,
          maintainState: true,
          child: const CameraView(
            key: CameraViewKey,
          ),
        ),
        Visibility(
          visible: !shouldShowCamera,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: Corners.borderRadius,
              image: DecorationImage(
                image: latestSnappedImage ?? AppImageAssets.transparentImage,
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
          onPressed: () => ref
              .read(cameraViewControllerProvider.notifier)
              .captureAndScan(context),
          duration: const Duration(milliseconds: 120),
          child: Card(
            elevation: 20,
            // To avoid weird shadow when the camera preview hasn't been displayed
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: Corners.borderRadius,
            ),
            child: Consumer(
              builder: (context, ref, _) {
                return AspectRatio(
                  // Changes the aspectRatio of this widget as same as CameraView.
                  // The aspectRatio used here is obtained from CameraController used in CameraView widget.
                  // When that aspectRatio is null, 2/3 is used as a fallback.
                  aspectRatio: ref.watch(cameraViewAspectRatioProvider),
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
