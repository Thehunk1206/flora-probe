import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:floraprobe/src/commons/string_const.dart';
import 'package:floraprobe/src/commons/styles.dart';
import 'package:floraprobe/src/ui/components/background_cover.dart';
import 'package:flutter/material.dart';

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
