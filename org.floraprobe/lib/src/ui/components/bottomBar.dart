import 'package:flutter/material.dart';

/// A custom bottom icon button bar
class BottomBar extends StatelessWidget {
  final List<Widget> items;

  /// Creates a custom bottom icon button bar
  const BottomBar({Key key, this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: SizedBox(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items,
        ),
      ),
    );
  }
}
