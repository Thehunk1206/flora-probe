import 'dart:ui';

import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/provider/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// A reusable, modal dialog
class ResultsDialog {
  BuildContext _dialogcontext;
  Widget buildOutput(List<dynamic> results) {
    Widget child;
    if (results?.isEmpty ?? true) {
      // No results
      child = Container(
        /// Box should be square, hence the restriction
        constraints: BoxConstraints.tight(
          Size(100, 100),
        ),
        // The illustration to show when list is empty
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AppImageAssets.foundNothing,
          ),
        ),
      );
      child = ConstrainedBox(
        // constraints to not let Material expand
        constraints: BoxConstraints.tight(
          Size(140, 140),
        ),
        child: Material(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
          child: Center(
            child: child,
          ),
        ),
      );
    } else {
      print('$results');

      /// Sample output
      /// [{confidence: 0.6125634908676147, index: 10, label: lilly}]
      List<Widget> children = [];
      for (var item in results) {
        double confidence = item['confidence'];
        String label = item['label'];
        Widget listItem = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Icon(
                Icons.texture,
                size: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Text(
                label,
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: const Color(0x29000000),
                      offset: Offset(3, 3),
                      blurRadius: 6,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Text(
                "${(confidence * 100).toString().substring(0, 5)}%",
                style: GoogleFonts.openSans(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: const Color(0x29000000),
                      offset: Offset(3, 3),
                      blurRadius: 6,
                    )
                  ],
                ),
              ),
            ),
            // icon
            // Wikipedia reference
          ],
        );
        listItem = Padding(
          padding:
              const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8, right: 8),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(10),
            color: confidence > 0.75
                ? Colors.green.withOpacity(confidence)
                : Colors.yellow.withOpacity(confidence + 0.10),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                bottom: 15.0,
              ),
              child: listItem,
            ),
          ),
        );
        children.add(listItem);
      }
      child = ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'Results',
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
            ),
          ),
          ...children,
        ],
      );
      child = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 250,
          maxHeight: (children.length + 1) * 70.0,
        ),
        child: Material(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
          child: Center(
            child: child,
          ),
        ),
      );
    }
    return child;
  }

  getContext(BuildContext context) {
    _dialogcontext = context;
  }

  /// Shows a modal dialog representing loading
  show(List<dynamic> results) async {
    const double _blurSigma = 1.5;
    dynamic _res = await showDialog<dynamic>(
      context: _dialogcontext,
      barrierDismissible: true,
      builder: (BuildContext context) {
        _dialogcontext = context;
        Widget child;
        child = buildOutput(results);
        return MediaQuery.removeViewInsets(
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
          context: context,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _blurSigma,
              sigmaY: _blurSigma,
            ),
            child: Center(
              child: child,
            ),
          ),
        );
      },
    );
    await dismiss();
    return _res;
  }

  /// Dismisses the dialog created by this Object
  Future<bool> dismiss() async {
    // if (_dialogcontext != null) {
    //   // Navigator.of(_dialogcontext).pop();
    //   _dialogcontext = null;
    // }
    Provider.of<HomeProvider>(_dialogcontext).setScanState(ScanState.idle);
    return true;
  }
}
