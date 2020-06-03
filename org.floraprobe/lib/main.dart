import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/provider/camera_view.dart';
import 'package:floraprobe/src/provider/probe.dart';
import 'package:floraprobe/src/provider/scanner.dart';
import 'package:floraprobe/src/provider/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:provider/provider.dart';

import 'src/commons/string_const.dart';
import 'src/commons/routes.dart';
import 'src/provider/history.dart';

void main() {
  // Ensuring that plugin services are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  /// Disables rotation to prevent side effects in Camera preview
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MyApp(),
  );
}

// This widget is the root of our application.
class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // Usually, without keys widgets unmounts and then mounts again and rebuilds. This behaviour may creates performance issues.
  // Thus, using keys below may cause widgets to update instead of remounting.
  // Using keys isn't neccessary as Flutter is fast but we don't want to remount heavy widgets hence the usage
  final _appKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    AppImageAssets.cacheMedia(context);
    return MultiProvider(
      providers: [
        Provider<Probe>(
          create: (context) => Probe(),
        ),
        ChangeNotifierProvider<Scanner>(
          create: (context) => Scanner(
            Provider.of<Probe>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<CameraViewNotifier>(
          create: (context) => CameraViewNotifier(),
        ),
        ChangeNotifierProvider<Settings>(
          create: (context) => Settings(),
        ),
        ChangeNotifierProvider<History>(
          create: (context) => History(),
        ),
      ],
      child: MaterialApp(
        key: _appKey,
        title: Strings.title,
        navigatorKey: navigatorKey,
        // generates routes for this app
        onGenerateRoute: generateRoute,
        theme: ThemeData(
          /// Yellow swatch is used in theme as it's the first color which comes in mind when
          /// thinking about flowers
          primarySwatch: Colors.lightGreen,
        ),
      ),
    );
  }
}
