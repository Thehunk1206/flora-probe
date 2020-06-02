import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Corners {
  /// The border radius of Card & Material widgets in this application.
  ///
  /// The value is same as [BorderRadius.circular(25.0)].
  static const BorderRadius borderRadius =
      const BorderRadius.all(Radius.circular(25.0));
}

class AppColors {
  static Color halfBlack = Colors.black.withOpacity(0.5);
  static Color halfWhite = Colors.white.withOpacity(0.5);
  static Color white = Colors.white;
}

class Paddings {
  static const EdgeInsetsGeometry padding8 = const EdgeInsets.all(8.0);
}

class TextStyles {
  static TextStyle defaultOpenSans = GoogleFonts.openSans(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    shadows: [
      Shadow(
        color: const Color(0x29000000),
        offset: Offset(3, 3),
        blurRadius: 6,
      )
    ],
  );

  static TextStyle resultLabelStyle = defaultOpenSans.copyWith(
    fontSize: 20,
  );

  static TextStyle resultConfidenceStyle = defaultOpenSans.copyWith(
    fontSize: 12,
  );

  static TextStyle tapToScanLabelStyle = defaultOpenSans.copyWith(
    color: const Color(0xfff8f5f5),
  );

  static TextStyle appbarTitle = GoogleFonts.dancingScript(
    fontSize: 40,
    fontWeight: FontWeight.w900,
  );
}
