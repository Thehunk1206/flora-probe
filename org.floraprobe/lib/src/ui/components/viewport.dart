import 'package:floraprobe/src/provider/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CameraView2.dart';
import 'dialog_of_result.dart';

class CameraViewport extends StatelessWidget {
  final ResultsDialog resultsDialog = ResultsDialog();
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      Widget child;
      resultsDialog.getContext(context);
      switch (provider.state) {
        case ScanState.idle:
          // Shows CameraView when ready to scan images.
          child = ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: CameraView(
              dialog: resultsDialog,
            ),
          );
          break;
        // Displays the snapped image when processing or showing results.
        case ScanState.running:
        case ScanState.completed:
          child = AspectRatio(
            aspectRatio: provider.aspectRatio ?? 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                image: DecorationImage(
                  image: provider.latestSnappedImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
          if (provider.state == ScanState.completed) {
            child = GestureDetector(
              onTap: () {
                provider.setScanState(ScanState.idle);
              },
              child: child,
            );
          }
          break;
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: child,
          ),
        ),
      );
    });
  }
}
