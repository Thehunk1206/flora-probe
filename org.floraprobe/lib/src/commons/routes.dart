import 'package:floraprobe/src/ui/screens/about.dart';
import 'package:floraprobe/src/ui/screens/history.dart';
import 'package:floraprobe/src/ui/screens/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Constant Strings which are all screen's uique path
import 'routing_const.dart';

// Screens
import '../ui/screens/home.dart';

/// Wraps [screen] with a [PageRoute]
PageRoute<T> wrapPageRoute<T>(Widget screen,
    [bool useCupertinoPageRoute = false]) {
  if (useCupertinoPageRoute) {
    return CupertinoPageRoute<T>(builder: (context) => screen);
  }
  return MaterialPageRoute<T>(
    builder: (context) => screen,
  );
}

/// Generates Routes which will be used in the application
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SettingsRoute:
      return wrapPageRoute<SettingsScreen>(
        SettingsScreen(),
        true,
      );
    case HistoryRoute:
      return wrapPageRoute<HistoryScreen>(
        HistoryScreen(),
        true,
      );
    case HomeRoute:
    default:
      return wrapPageRoute<HomeScreen>(
        // The main homescreen of this application
        HomeScreen(
          key: HomeRouteKey,
        ),
      );
  }
}
