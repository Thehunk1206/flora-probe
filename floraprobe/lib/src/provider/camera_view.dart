import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/camera_view.dart';

final cameraViewControllerProvider =
    StateNotifierProvider<CameraViewController, CameraController?>((ref) {
  return CameraViewController(ref);
});

final cameraViewCameraControllerProvider = ChangeNotifierProvider((ref) {
  return ref.watch(cameraViewControllerProvider);
});

final cameraViewAspectRatioProvider = Provider((ref) {
  return ref.watch(cameraViewCameraControllerProvider.select(
    (value) => value?.value.aspectRatio ?? 2 / 3,
  ));
});
