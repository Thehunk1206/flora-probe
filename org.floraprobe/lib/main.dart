import 'package:floraprobe/src/provider/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:provider/provider.dart';

import 'src/commons/string_const.dart';
import 'src/commons/routes.dart';

void main() {
  // Ensuring that plugin services are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  /// Disables rotation to prevent side effects in Camera preview
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // this is the main provider which handles app state
          create: (context) => HomeProvider(context),
        ),
      ],
      child: MyApp(),
    ),
  );
}

// This widget is the root of our application.
class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.title,
      navigatorKey: navigatorKey,
      // generates routes for this app
      onGenerateRoute: generateRoute,
      theme: ThemeData(
        /// Yellow swatch is used in theme as it's the first color which comes in mind when
        /// thinking about flowers
        primarySwatch: Colors.yellow,
      ),
    );
  }
}
