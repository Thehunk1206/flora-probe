import 'package:floraprobe/src/commons/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class BouncingButton extends StatelessWidget {
  final double size;
  final Widget icon;
  final VoidCallback onPressed;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String? tooltip;

  /// Creates an icon button which bounces on tap.
  const BouncingButton({
    super.key,
    required this.size,
    required this.icon,
    required this.onPressed,
    this.decoration,
    this.padding,
    this.margin,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Bounce(
      duration: const Duration(
        milliseconds: 150,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Container(
          decoration: decoration ??
              BoxDecoration(
                color: AppColors.halfBlack,
                shape: BoxShape.circle,
              ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(8.0),
            child: SizedBox(
              height: size,
              width: size,
              child: Center(
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );
    child = Tooltip(
      message: tooltip,
      child: child,
    );
    return child;
  }
}
