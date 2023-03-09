import 'package:floraprobe/src/controllers/scanner.dart';
import 'package:floraprobe/src/provider/probe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scannerProvider = StateNotifierProvider<Scanner, ScannerState>((ref) {
  return Scanner(ref.watch(probeProvider));
});
