import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'scanner_widget.dart';

/// Shows scanning animation above child
class ScannerAnimationWrap extends StatefulWidget {
  final Widget child;
  const ScannerAnimationWrap({super.key, required this.child});

  @override
  _ScannerAnimationWrapState createState() => _ScannerAnimationWrapState();
}

class _ScannerAnimationWrapState extends State<ScannerAnimationWrap>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _animationStopped = false;
  bool scanning = false;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    doAnimate();
    super.initState();
  }

  void doAnimate() {
    if (!scanning) {
      animateScanAnimation(false);
      setState(() {
        _animationStopped = false;
        scanning = true;
      });
    } else {
      setState(() {
        _animationStopped = true;
        scanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(children: [
            Center(child: widget.child),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //         border: Border.all(color: CupertinoColors.white),
            //         borderRadius:
            //             BorderRadius.all(Radius.circular(12))),
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.all(Radius.circular(12)),
            //       child: Image(
            //           width: 334,
            //           image: NetworkImage(
            //               "https://images.pexels.com/photos/1841819/pexels-photo-1841819.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260")),
            //     ),
            //   ),
            // ),
            ImageScannerAnimation(
              _animationStopped,
              334,
              animation: _animationController,
            )
          ]),
        ]);
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
