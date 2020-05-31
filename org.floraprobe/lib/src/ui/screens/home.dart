import 'dart:ui';

import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/provider/home.dart';
import 'package:floraprobe/src/ui/components/bottomBar.dart';
import 'package:floraprobe/src/ui/components/scannerSVG.dart';
import 'package:floraprobe/src/ui/components/viewport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:provider/provider.dart';

/// The main app screen of flora probe
class HomeScreen extends StatelessWidget {
  final String title;

  HomeScreen({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double _size = 40;
    Text _appbarTitle = Text(
      title,
      style: GoogleFonts.dancingScript(
        fontSize: _size,
        fontWeight: FontWeight.w900,
      ),
      textAlign: TextAlign.left,
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

    /// This widget is useless and is just for decoration purposes
    Widget _decorationScannerView = Center(
      child: SvgPicture.string(
        scannerSVG,
        allowDrawingOutsideViewBox: true,
      ),
    );

    /// This widget is useless and is just for decoration purposes.
    ///
    /// Instructs user to tap for starting scanning.
    Widget _tapInstructionText = Center(
      child: Text(
        'Tap to Scan',
        style: GoogleFonts.openSans(
          fontSize: 18,
          color: const Color(0xfff8f5f5),
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: const Color(0x29000000),
              offset: Offset(3, 3),
              blurRadius: 6,
            )
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
    Widget _settingsButton = Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        iconSize: _size,
        onPressed: () {
          print('Settings');
        },
        splashColor: Colors.white,
        icon: Icon(
          EvaIcons.options2Outline,
          color: Colors.white,
        ),
      ),
    );
    Widget _historyButton = IconButton(
      iconSize: _size,
      onPressed: () {
        print('History');
      },
      splashColor: Colors.white,
      icon: Container(
        height: _size,
        width: _size,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AppImageAssets.flowerIcon,
          ),
        ),
      ),
    );
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
          // backgroundColor: Colors.transparent,
          backgroundColor: Colors.black.withOpacity(0.2),
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

              /// Hide scanner decoration when running
              Visibility(
                visible:
                    Provider.of<HomeProvider>(context).state == ScanState.idle,
                child: _decorationScannerView,
              ),
              Visibility(
                visible:
                    Provider.of<HomeProvider>(context).state == ScanState.idle,
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
