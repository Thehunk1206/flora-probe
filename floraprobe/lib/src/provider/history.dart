import 'package:floraprobe/src/controllers/history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyControllerProvider =
    StateNotifierProvider<HistoryController, List<History>>((ref) {
  return HistoryController();
});
