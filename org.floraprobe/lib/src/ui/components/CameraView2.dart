import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:floraprobe/src/provider/home.dart';
import 'package:floraprobe/src/ui/components/dialog_of_result.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:provider/provider.dart';

import 'dialog.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;
  final ResultsDialog dialog;
  const CameraView({Key key, this.cameras, this.dialog}) : super(key: key);
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController controller;
  List<CameraDescription> cameras;
  final Loading loading = Loading();

  bool hasError = false;

  @override
  void initState() {
    super.initState();
    acquireCamera(); // Try acquiring available cameras
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> acquireCamera() async {
    try {
      cameras = await availableCameras();
    } on CameraException {
      print('[CameraException] Couldn\'t acquire camera');
      setState(() {
        hasError = true;
      });
      return;
    }
    hasError = false;
    controller = CameraController(cameras.first, ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      // show option to retry
      return Center(
        child: Icon(
          EvaIcons.alertCircleOutline,
          color: Colors.red,
        ),
      );
    }
    if (!(controller?.value?.isInitialized ?? false)) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return GestureDetector(
      onTap: () async {
        List<dynamic> res;
        loading.show(context);
        // Take the Picture in a try / catch block. If anything goes wrong,
        // catch the error.
        try {
          // Construct the path where the image should be saved
          // package.
          final path = p.join(
            // Store the picture in the temp directory.
            (await pp.getTemporaryDirectory()).path,
            '${DateTime.now()}.png',
          );

          // Attempt to take a picture and log where it's been saved.
          await controller.takePicture(path);
          res = await Provider.of<HomeProvider>(context, listen: false)
              .searchImage(path, controller, context, loading);
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }

        // Showing results in dialog
        await widget.dialog.show(res);
        // Resume camera preview
        // Provider.of<HomeProvider>(context, listen: false)
        //     .setScanState(ScanState.idle);
      },
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      ),
    );
  }
}
