import 'package:floraprobe/src/controllers/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:floraprobe/src/commons/routing_const.dart';
import 'package:floraprobe/src/provider/scanner.dart';
import 'package:floraprobe/src/ui/components/decorations/background_cover.dart';
import 'package:floraprobe/src/ui/components/buttons/bouncing_button.dart';
import 'package:floraprobe/src/ui/components/buttons/iconlabel_button.dart';
import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/commons/string_const.dart';
import 'package:floraprobe/src/commons/styles.dart';
import 'package:floraprobe/src/ui/components/widgets/bottomBar.dart';
import 'package:floraprobe/src/ui/components/widgets/scanner_view.dart';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';

/// The main app screen of flora probe
class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double size = 40;
    Text appbarTitle = Text(
      Strings.title,
      style: TextStyles.appTitle,
    );

    // TODO: Bounce effect when CameraView is tapped
    /// This widget is useless and is just for decoration purposes
    Widget decorationScannerView = IgnorePointer(
      ignoring: true,
      child: Center(
        child: AppImageAssets.scannerVector,
      ),
    );

    /// This widget is useless and is just for decoration purposes.
    ///
    /// Instructs user to tap for starting scanning.
    Widget tapInstructionText = IgnorePointer(
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
    Widget historyButton = BouncingButton(
      icon: const FaIcon(
        FontAwesomeIcons.history,
        color: Colors.white,
      ),
      size: size,
      tooltip: 'Show history',
      onPressed: () {
        Navigator.of(context).pushNamed(HistoryRoute);
      },
    );

    Widget settingsButton = BouncingButton(
      size: size,
      onPressed: () {
        Navigator.of(context).pushNamed(SettingsRoute);
      },
      tooltip: 'Open settings',
      icon: Icon(
        EvaIcons.options2Outline,
        color: AppColors.white,
        size: size,
      ),
    );
    final double scannerDecorationOpacity = ref.watch(scannerProvider.select(
      (value) => value.step == ScannerStateStep.ready ? 1 : 0,
    ));
    const Duration opacityAnimationDuration = Duration(
      milliseconds: 200,
    );
    return BackgroundCover(
      child: Scaffold(
        // backgroundColor: const Color(0xfffcffa4),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: appbarTitle,
          actions: const <Widget>[
            IconLabelButton(),
            SizedBox(
              width: 5,
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            const ScannerView(
              key: CameraVPKey,
            ),
            // Hide scanner decoration when running
            AnimatedOpacity(
              opacity: scannerDecorationOpacity,
              duration: opacityAnimationDuration,
              child: decorationScannerView,
            ),
            AnimatedOpacity(
              opacity: scannerDecorationOpacity,
              duration: opacityAnimationDuration,
              child: tapInstructionText,
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(
          items: <Widget>[
            settingsButton,
            historyButton,
          ],
        ),
      ),
    );
  }
}
