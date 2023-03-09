import 'package:floraprobe/src/controllers/probe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final probeProvider = Provider((ref) {
  return Probe();
});
