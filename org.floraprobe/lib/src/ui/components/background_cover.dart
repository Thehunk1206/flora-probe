import 'package:floraprobe/src/commons/assets.dart';
import 'package:flutter/material.dart';

class BackgroundCover extends StatelessWidget {
  final Widget child;

  const BackgroundCover({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AppImageAssets.flowerBackground,
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
