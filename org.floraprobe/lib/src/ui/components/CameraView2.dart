import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:floraprobe/src/commons/styles.dart';
import 'package:floraprobe/src/provider/home.dart';
import 'package:floraprobe/src/ui/components/result_dialog.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:provider/provider.dart';

import 'loading_dialog.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;
  final ResultsDialog dialog;
  const CameraView({Key key, this.cameras, this.dialog}) : super(key: key);
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController controller;
  List<CameraDescription> cameras;
  final Loading loading = Loading();
  HomeProvider deafProvider;

  bool hasError = false;

  @override
  void initState() {
    super.initState();
    deafProvider = Provider.of<HomeProvider>(context, listen: false);
    _setupCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('Application life state - $state');
    if (state == AppLifecycleState.resumed) {
      //on pause camera is disposed, so we need to call again "issue is only for android"
      if (controller != null) _initializeCamera();
    } else {
      if (!mounted) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _setupCamera() async {
    await _acquireCamera(); // Try acquiring available cameras
    controller = CameraController(cameras.first, ResolutionPreset.medium);
    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      if (controller.value.isInitialized ?? false) {
        // Update aspect ratio when controller is initialized
        deafProvider.setAspectRatio(controller.value.aspectRatio);
      }
    });
  }

  Future<void> _acquireCamera() async {
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
          child: CircularProgressIndicator(
            strokeWidth: 10,
          ),
        ),
      );
    }
    return Bounce(
      duration: const Duration(
        milliseconds: 120,
      ),
      onPressed: () async {
        deafProvider.setScanState(ScanState.initializing);
        List<dynamic> res;
        loading.show(context);
        // Take the Picture in a try / catch block. If anything goes wrong,
        // catch the error.
        try {
          // Construct the path where the image should be saved
          // package.
          final String path = p.join(
            // Store the picture in the temp directory.
            (await pp.getTemporaryDirectory()).path,
            '${DateTime.now()}.png',
          );

          // Attempt to take a picture and log where it's been saved.
          await controller.takePicture(path);
          res = await deafProvider.searchImage(
              path, controller, context, loading);
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }

        // Showing results in dialog
        await widget.dialog.show(res);

        // Resume camera preview
        deafProvider.setScanState(ScanState.ready);
      },
      child: ClipRRect(
        borderRadius: Corners.borderRadius,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}
