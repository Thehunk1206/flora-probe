import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/commons/assets.dart';
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
    ProviderScope(child: MyApp()),
  );
}

// Usually, without keys widgets unmounts and then mounts again and rebuilds. This behaviour may creates performance issues.
// Thus, using keys below may cause widgets to update instead of remounting.
// Using keys isn't necessary as Flutter is fast but we don't want to remount heavy widgets hence the usage
final _appKey = GlobalKey();

// This widget is the root of our application.
class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    AppImageAssets.cacheMedia(context);
    return MaterialApp(
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
    );
  }
}
