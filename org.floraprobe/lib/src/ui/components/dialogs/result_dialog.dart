import 'dart:ui';

import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/commons/string_const.dart';
import 'package:floraprobe/src/commons/styles.dart';
import 'package:flutter/material.dart';

/// A reusable, modal dialog
class ResultsDialog {
  BuildContext _dialogcontext;

  /// Equivalent of Colors.red
  static const HSVColor _red = const HSVColor.fromAHSV(1, 4, 0.779, 0.957);

  /// Equivalent of Colors.green
  static const HSVColor _green = const HSVColor.fromAHSV(1, 122, 0.566, 0.686);

  /// Returns appropriate color for result Card based on it's confidence
  static Color _colorOf(double confidence) {
    return HSVColor.lerp(_red, _green, confidence).toColor();
  }

  double _getConstrainedBoxHeight(int numOfChildren) {
    if (numOfChildren > 4) {
      return 5.0 * 70.0;
    } else {
      return (numOfChildren + 1) * 70.0;
    }
  }

  Widget _buildOutput(List<dynamic> results) {
    Widget child;
    if (results?.isEmpty ?? true) {
      // No results
      child = Container(
        // Controls image size under constraints
        margin: EdgeInsets.all(20),
        // The illustration to show when list is empty
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AppImageAssets.foundNothing,
          ),
        ),
      );
      child = Center(
        child: ConstrainedBox(
          /// Box should be square, hence the restriction
          constraints: BoxConstraints.tight(Size(150, 150)),
          child: Material(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(25),
            child: child,
          ),
        ),
      );
    } else {
      // TODO: This looks like a good place to note for history

      /// Sample output
      /// [{confidence: 0.6125634908676147, index: 10, label: lilly}]
      List<Widget> children = [];
      for (var item in results) {
        double confidence = item['confidence'];
        String label = item['label'];
        Widget listItem = Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Icon(
                Icons.texture,
                size: 30,
              ),
            ),
            Text(
              label,
              style: TextStyles.resultLabelStyle,
              softWrap: true,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                "${(confidence * 100).toString().substring(0, 5)}%",
                style: TextStyles.resultConfidenceStyle,
              ),
            ),
            // icon
            // Wikipedia reference
          ],
        );
        // The Card of result
        listItem = Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          color: _colorOf(confidence),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              bottom: 15.0,
            ),
            child: listItem,
          ),
        );
        children.add(listItem);
      }
      child = ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.all(16),
        children: [
          Text(
            Strings.results,
            textAlign: TextAlign.left,
            style: TextStyles.tapToScanLabelStyle,
          ),
          SizedBox(
            height: 8,
          ),
          ...children,
        ],
      );
      child = Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _getConstrainedBoxHeight(results.length),
            ),
            child: Material(
              color: AppColors.halfWhite,
              borderRadius: Corners.borderRadius,
              child: child,
            ),
          ),
        ),
      );
    }
    return child;
  }

  /// Shows a modal dialog representing.
  Future<dynamic> show(List<dynamic> results, BuildContext context) async {
    dynamic _res = await showDialog<dynamic>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        _dialogcontext = context;
        return MediaQuery.removeViewInsets(
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
          context: context,
          child: GestureDetector(
            onTap: () {
              hide();
            },
            child: Container(
              color: Colors.transparent,
              // constraints: BoxConstraints(
              //   maxHeight: getConstrainedBoxHeight(results.length),
              // ),
              child: _buildOutput(results),
            ),
          ),
        );
      },
    );
    return _res;
  }

  /// Dismisses the dialog created by this Object.
  Future<void> hide() async {
    Navigator.of(_dialogcontext).pop();
  }
}
