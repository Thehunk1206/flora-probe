import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '../../commons/string_const.dart';
import '../../commons/styles.dart';

import '../components/decorations/background_cover.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Text appbarTitle = Text(
      Strings.historyTitle,
      style: TextStyles.appbarTitle,
    );
    return BackgroundCover(
      child: Scaffold(
        backgroundColor: AppColors.lightGreen20,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              EvaIcons.arrowIosBackOutline,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          backgroundColor: AppColors.appbarColor,
          elevation: 0,
          title: appbarTitle,
        ),
        body: ListView(),
      ),
    );
  }
}
