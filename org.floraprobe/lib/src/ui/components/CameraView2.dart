import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:floraprobe/src/commons/styles.dart';
import 'package:floraprobe/src/provider/camera_view.dart';
import 'package:floraprobe/src/ui/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

import 'loading_dialog.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraView({Key key, this.cameras}) : super(key: key);
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController controller;
  List<CameraDescription> cameras = [];
  final Loading loading = Loading();

  /// HomeProvider with listen false
  CameraViewNotifier deafProvider;

  bool hasError = false;
  bool init = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    deafProvider = Provider.of<CameraViewNotifier>(context, listen: false);
    _setupCamera();
    init = false;
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // on pause camera is disposed, so we need to call again
        if (controller != null) {
          // Resuming camera
          _initializeCamera();
        } else {
          // Re-initializing camera
          _setupCamera();
        }
        break;
      case AppLifecycleState.paused:
        //  camera should be closed when our activity reaches onPause().
        if (controller != null) controller.dispose();
        // Because of an issue with camera plugin, we are assigning null to it
        controller = null;
        init = false;
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
    }
  }

  Future<void> _setupCamera() async {
    if (cameras.isEmpty)
      await _acquireCamera(); // Try acquiring available cameras
    print('Acquired camera');
    controller = CameraController(cameras.first, ResolutionPreset.medium,
        enableAudio: false);
    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (!init) {
      // To prevent fatal crash, ensure that initialize is ran only once before this
      // method completes
      // Message on crash:
      // ```
      // Shutting down VM
      // FATAL EXCEPTION: main
      // ```
      init = true;
      await controller.initialize();
    }
    if (!mounted) {
      return;
    }
    setState(() {});
    if (controller.value.isInitialized ?? false) {
      deafProvider.setCameraController(controller);
    }
  }

  Future<void> _acquireCamera() async {
    try {
      cameras = await availableCameras();
    } on CameraException {
      print('Couldn\'t acquire camera');
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
      return CircularLoading(
        useScaffold: false,
      );
    }
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: Corners.borderRadius,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      ),
    );
  }
}
