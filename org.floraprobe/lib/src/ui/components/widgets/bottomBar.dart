import 'package:flutter/material.dart';

/// A custom icon-button bar
class BottomBar extends StatelessWidget {
  final List<Widget> items;

  /// Creates a custom bottom icon button bar
  const BottomBar({Key key, this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 8),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items,
        ),
      ),
    );
  }
}
