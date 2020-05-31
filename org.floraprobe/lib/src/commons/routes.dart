import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// consts
import 'string_const.dart';
// Constant Strings which are all screen's uique path
import 'routing_const.dart';

// Screens
import '../ui/screens/home.dart';

/// Wraps [screen] with a [PageRoute]
PageRoute<T> wrapPageRoute<T>(Widget screen,
    [bool useCupertinoPageRoute = true]) {
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
    case HomeRoute:
    default:
      return wrapPageRoute<HomeScreen>(
        // The main homescreen of this application
        HomeScreen(
          title: Strings.title,
        ),
      );
  }
}
