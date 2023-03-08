import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '../../commons/string_const.dart';
import '../../commons/styles.dart';

import '../components/decorations/background_cover.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Text _appbarTitle = Text(
      Strings.historyTitle,
      style: TextStyles.appbarTitle,
    );
    return BackgroundCover(
      child: Scaffold(
        backgroundColor: AppColors.lightGreen20,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              EvaIcons.arrowIosBackOutline,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          backgroundColor: AppColors.appbarColor,
          elevation: 0,
          title: _appbarTitle,
        ),
        body: ListView(),
      ),
    );
  }
}
