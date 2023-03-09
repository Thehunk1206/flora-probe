import 'package:flutter_riverpod/flutter_riverpod.dart';

class History {}

class HistoryController extends StateNotifier<List<History>> {
  HistoryController() : super([]);
}
