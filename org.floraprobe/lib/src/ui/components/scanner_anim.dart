import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'scanner_widget.dart';

/// Shows scanning animation above child
class ScannerAnimationWrap extends StatefulWidget {
  final Widget child;
  const ScannerAnimationWrap({Key key, this.child}) : super(key: key);
  @override
  _ScannerAnimationWrapState createState() => _ScannerAnimationWrapState();
}

class _ScannerAnimationWrapState extends State<ScannerAnimationWrap>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _animationStopped = false;
  String scanText = "Scan";
  bool scanning = false;

  @override
  void initState() {
    _animationController = new AnimationController(
        duration: new Duration(seconds: 1), vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Scanning Animation")),
      child: SafeArea(
        child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: CupertinoColors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Image(
                              width: 334,
                              image: NetworkImage(
                                  "https://images.pexels.com/photos/1841819/pexels-photo-1841819.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260")),
                        ),
                      ),
                    ),
                    ImageScannerAnimation(
                      _animationStopped,
                      334,
                      animation: _animationController,
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: CupertinoButton(
                      color: CupertinoColors.activeGreen,
                      onPressed: () {
                        if (!scanning) {
                          animateScanAnimation(false);
                          setState(() {
                            _animationStopped = false;
                            scanning = true;
                            scanText = "Stop";
                          });
                        } else {
                          setState(() {
                            _animationStopped = true;
                            scanning = false;
                            scanText = "Scan";
                          });
                        }
                      },
                      child: Text(scanText),
                    ),
                  )
                ])),
      ),
    );
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