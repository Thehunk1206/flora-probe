import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:floraprobe/src/commons/string_const.dart';
import 'package:floraprobe/src/commons/styles.dart';
import 'package:floraprobe/src/ui/components/decorations/background_cover.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Text _appbarTitle = Text(
      Strings.settingsTitle,
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
          elevation: 1,
          title: _appbarTitle,
        ),
        body: ListView(),
      ),
    );
  }
}
