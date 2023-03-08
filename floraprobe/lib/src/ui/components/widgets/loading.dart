import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  final bool useScaffold;
  final bool useWhiteBackground;
  const CircularLoading({
    super.key,
    this.useScaffold = true,
    this.useWhiteBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = const Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
      ),
    );
    if (useScaffold) {
      child = Scaffold(body: child);
    } else if (useWhiteBackground) {
      child = DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: child,
      );
    }
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: Colors.yellow,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.lightGreenAccent)
            .copyWith(background: Colors.lightGreen),
      ),
      child: child,
    );
  }
}
