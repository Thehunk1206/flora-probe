import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/probe.dart';

enum ScannerStateStep {
  /// ready to capture image to run scan on
  ready,

  /// Initializing scan
  initializing,

  /// Running ML model on image
  running,

  /// Scan completed
  completed,
}

class ScannerState {
  final ScannerStateStep step;
  final ImageProvider? latestSnappedImage;

  const ScannerState({
    this.step = ScannerStateStep.ready,
    this.latestSnappedImage,
  });

  ScannerState copyWith({
    ScannerStateStep? step,
    ImageProvider? latestSnappedImage,
  }) {
    return ScannerState(
      step: step ?? this.step,
      latestSnappedImage: latestSnappedImage ?? this.latestSnappedImage,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ScannerState &&
        other.step == step &&
        other.latestSnappedImage == latestSnappedImage;
  }

  @override
  int get hashCode => Object.hash(step, latestSnappedImage);
}

class Scanner extends StateNotifier<ScannerState> {
  Scanner(this.probe) : super(const ScannerState());

  @override
  ScannerState get state => super.state;

  final Probe probe;

  Future<void> setLatestSnappedImage(
    BuildContext context,
    ImageProvider image,
  ) async {
    state = state.copyWith(
      latestSnappedImage: image,
    );
    await precacheImage(image, context);
  }

  void updateStep(ScannerStateStep step) {
    state = state.copyWith(
      step: step,
    );
  }

  @override
  void dispose() {
    probe.dispose();
    super.dispose();
  }

// Dont forget to hide loading dialog
  Future<List<dynamic>?> scanImage(
      XFile imageFile, BuildContext context) async {
    // Starting theatrics
    try {
      final io.File imageFile0 = io.File(imageFile.path);
      await setLatestSnappedImage(
        context,
        FileImage(
          imageFile0,
        ),
      );
      updateStep(ScannerStateStep.running);
    } catch (e) {
      print(e);
      // Dismissing dialog on error
      updateStep(ScannerStateStep.ready);
      return null;
    }

    // Runs Model
    List? results = await probe.runModelFrom(imageFile.path);
    updateStep(ScannerStateStep.completed);
    return results;
  }
}
