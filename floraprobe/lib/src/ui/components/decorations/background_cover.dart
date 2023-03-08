import 'package:floraprobe/src/commons/assets.dart';
import 'package:flutter/material.dart';

class BackgroundCover extends StatelessWidget {
  final Widget child;

  const BackgroundCover({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AppImageAssets.flowerBackground,
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
