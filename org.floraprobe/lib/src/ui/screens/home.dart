import 'dart:ui';

import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/commons/string_const.dart';
import 'package:floraprobe/src/commons/styles.dart';
import 'package:floraprobe/src/provider/home.dart';
import 'package:floraprobe/src/ui/components/bottomBar.dart';
import 'package:floraprobe/src/ui/components/scannerSVG.dart';
import 'package:floraprobe/src/ui/components/viewport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:provider/provider.dart';

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
      style: TextStyles.appbarTitle,
    );

    IconButton _searchButton = IconButton(
      icon: Icon(
        EvaIcons.search,
      ),
      iconSize: _size,
      onPressed: () {
        print("Search");
      },
    );
    Widget _cameraViewport = CameraViewport();

    // TODO: Bounce effect when CameraView is tapped
    /// This widget is useless and is just for decoration purposes
    Widget _decorationScannerView = IgnorePointer(
      ignoring: true,
      child: Center(
        child: SvgPicture.string(
          scannerSVG,
          allowDrawingOutsideViewBox: true,
        ),
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

    Widget _settingsButton = Bounce(
      duration: const Duration(
        milliseconds: 150,
      ),
      onPressed: () {
        print('Settings');
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.halfBlack,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: _size,
            width: _size,
            child: Center(
              child: Icon(
                EvaIcons.options2Outline,
                color: AppColors.white,
                size: _size,
              ),
            ),
          ),
        ),
      ),
    );

    Widget _historyButton = Bounce(
      duration: const Duration(
        milliseconds: 150,
      ),
      onPressed: () {
        print('History');
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.halfBlack,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(
            height: _size,
            width: _size,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AppImageAssets.flowerIcon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final bool _isScannerDecorationVisible =
        Provider.of<HomeProvider>(context).state == ScanState.ready;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AppImageAssets.flowerBackground,
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        // filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
        child: Scaffold(
          // backgroundColor: const Color(0xfffcffa4),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: _appbarTitle,
            actions: <Widget>[
              _searchButton,
            ],
          ),
          body: Stack(
            children: <Widget>[
              _cameraViewport,
              // Hide scanner decoration when running
              AnimatedOpacity(
                opacity: _isScannerDecorationVisible ? 1 : 0,
                duration: const Duration(
                  milliseconds: 200,
                ),
                child: _decorationScannerView,
              ),
              AnimatedOpacity(
                opacity: _isScannerDecorationVisible ? 1 : 0,
                duration: const Duration(
                  milliseconds: 200,
                ),
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
      ),
    );
  }
}
