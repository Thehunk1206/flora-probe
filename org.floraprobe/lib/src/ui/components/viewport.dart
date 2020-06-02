import 'package:floraprobe/src/commons/styles.dart';
import 'package:floraprobe/src/provider/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CameraView2.dart';
import 'result_dialog.dart';

class CameraViewport extends StatelessWidget {
  final ResultsDialog resultsDialog = ResultsDialog();
  @override
  Widget build(BuildContext context) {
    HomeProvider provider = Provider.of<HomeProvider>(context);
    // If HomeProvider().state is ScanState.idle then this child will be a live camera preview
    // else this viewportChild will be the latest snapshot took from camera.
    Widget viewportChild;
    // The result dialog will be shown above this child.
    // As the child changes based on ScanState, the context above it has to be used
    // to let the resultsDialog be displayed.
    resultsDialog.getContext(context);
    // This switch-case changes the child based on ScanState of HomeProvider().state
    switch (provider.state) {
      case ScanState.ready:
      case ScanState.initializing:
        // Shows CameraView when ready to scan images.
        viewportChild = CameraView(
          // The instance of resultsDialog is used which has context of this widget
          dialog: resultsDialog,
        );
        break;
      // Displays the snapped image when processing or showing results.
      case ScanState.running:
      case ScanState.completed:
        viewportChild = Container(
          decoration: BoxDecoration(
            borderRadius: Corners.borderRadius,
            image: DecorationImage(
              image: provider.latestSnappedImage,
              fit: BoxFit.cover,
            ),
          ),
        );
        break;
    }

    // This is the widget onto which the `viewportChild` will be shown
    return Center(
      child: Padding(
        padding: Paddings.padding8,
        child: Card(
          elevation: 20,
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: Corners.borderRadius,
          ),
          child: AspectRatio(
            // Changes the aspectRatio of this widget as same as CameraView.
            // The aspectRatio used here is obtained from CameraController used in CameraView widget.
            // When that aspectRatio is null, 16/9 is used as a fallback.
            aspectRatio: provider?.aspectRatio ?? 16 / 9,
            child: viewportChild,
          ),
        ),
      ),
    );
  }
}
