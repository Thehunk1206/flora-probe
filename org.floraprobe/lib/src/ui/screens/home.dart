import 'dart:ui';

import 'package:floraprobe/src/commons/routing_const.dart';
import 'package:floraprobe/src/provider/scanner.dart';
import 'package:floraprobe/src/ui/components/background_cover.dart';
import 'package:floraprobe/src/ui/components/bouncing_button.dart';
import 'package:floraprobe/src/ui/components/iconlabel_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/commons/string_const.dart';
import 'package:floraprobe/src/commons/styles.dart';
import 'package:floraprobe/src/ui/components/bottomBar.dart';
import 'package:floraprobe/src/ui/components/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

/// The main app screen of flora probe
class HomeScreen extends StatelessWidget {
  HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double _size = 40;
    Text _appbarTitle = Text(
      Strings.title,
      style: TextStyles.appTitle,
    );

    // TODO: Bounce effect when CameraView is tapped
    /// This widget is useless and is just for decoration purposes
    Widget _decorationScannerView = IgnorePointer(
      ignoring: true,
      child: Center(
        child: AppImageAssets.scannerVector,
      ),
    );

    /// This widget is useless and is just for decoration purposes.
    ///
    /// Instructs user to tap for starting scanning.
    Widget _tapInstructionText = IgnorePointer(
      ignoring: true,
      child: Center(
        child: Text(
          'Tap to Scan',
          style: TextStyles.tapToScanLabelStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );

    /// Buttons ===
    Widget _historyButton = BouncingButton(
      icon: FaIcon(
        FontAwesomeIcons.history,
        color: Colors.white,
      ),
      size: _size,
      tooltip: 'Show history',
      onPressed: () {
        Navigator.of(context).pushNamed(HistoryRoute);
      },
    );

    Widget _settingsButton = BouncingButton(
      size: _size,
      onPressed: () {
        Navigator.of(context).pushNamed(SettingsRoute);
      },
      tooltip: 'Open settings',
      icon: Icon(
        EvaIcons.options2Outline,
        color: AppColors.white,
        size: _size,
      ),
    );

    final double _scannerDecorationOpacity =
        Provider.of<Scanner>(context).state == ScannerState.ready ? 1 : 0;
    final Duration _opacityAnimationDuration = const Duration(
      milliseconds: 200,
    );
    return BackgroundCover(
      child: Scaffold(
        // backgroundColor: const Color(0xfffcffa4),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: _appbarTitle,
          actions: <Widget>[
            IconLabelButton(),
            SizedBox(
              width: 5,
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            ScannerView(
              key: CameraVPKey,
            ),
            // Hide scanner decoration when running
            AnimatedOpacity(
              opacity: _scannerDecorationOpacity,
              duration: _opacityAnimationDuration,
              child: _decorationScannerView,
            ),
            AnimatedOpacity(
              opacity: _scannerDecorationOpacity,
              duration: _opacityAnimationDuration,
              child: _tapInstructionText,
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(
          items: <Widget>[
            _settingsButton,
            _historyButton,
          ],
        ),
      ),
    );
  }
}
