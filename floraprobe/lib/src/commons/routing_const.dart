import 'package:flutter/foundation.dart';

const String HomeRoute = '/';
const String SettingsRoute = '/settings';
const String HistoryRoute = '/history';

// Here, the value of this key below is compared when widgets are refreshed. If the value matches
// with an existing key in the widget tree, then the widget updates instead of remounting.
const ValueKey<String> HomeRouteKey = ValueKey<String>('homeScreen');

const ValueKey<String> CameraVPKey = ValueKey<String>('CameraVPScreen');

const ValueKey<String> CameraViewKey = ValueKey<String>('CameraViewScreen');
