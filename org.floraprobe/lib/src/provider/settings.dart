import 'package:floraprobe/src/models/settings.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pp;

// TODO: Tests, and saving + retrieving settings, history
class Settings with ChangeNotifier {
  Box<SettingsBox> _settingsBox;
  SettingsBox _settings;
  Settings() {
    Hive.registerAdapter(SettingsBoxAdapter());
    _openBox();
  }

  Future _openBox() async {
    var hiveSaveDir = await pp.getApplicationDocumentsDirectory();
    Hive.init(hiveSaveDir.path);
    _settingsBox = await Hive.openBox('settingsBox');
    await setup();
    print("Listening changes in Settings");
    _settingsBox.watch().listen(onSettingsChange);
  }

  Future<void> setup() async {
    if (!isInitialized()) throw Exception();
    if (!hasPrefs()) {
      await _settingsBox.add(SettingsBox.initial());
    }
    _settings = _settingsBox.values.toList()[0];
  }

  bool isInitialized() {
    return _settingsBox?.isOpen ?? false;
  }

  bool hasPrefs() {
    return _settingsBox.isNotEmpty;
  }

  void onSettingsChange(BoxEvent boxEvent) {}
}
