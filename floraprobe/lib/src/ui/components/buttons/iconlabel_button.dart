import 'package:floraprobe/src/commons/assets.dart';
import 'package:floraprobe/src/commons/string_const.dart';
import 'package:floraprobe/src/commons/styles.dart';
import 'package:floraprobe/src/ui/screens/about.dart';
import 'package:flutter/material.dart';

class IconLabelButton extends StatelessWidget {
  const IconLabelButton({super.key});

  @override
  Widget build(BuildContext context) {
    final iconSize = IconTheme.of(context).size ?? 28;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Tooltip(
            message: 'Show about us',
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
              ),
              onPressed: () {
                showMyAboutDialog(
                  context: context,
                  applicationName: '',
                  applicationVersion: Strings.applicationVersion,
                  applicationIcon: Text(
                    Strings.title,
                    style: TextStyles.appTitle.copyWith(
                      fontSize: 30,
                    ),
                  ),
                  children: [
                    Text(
                      Strings.applicationAbout,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ],
                );
              },
              icon: Container(
                height: iconSize,
                width: iconSize,
                alignment: const Alignment(0, 0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AppImageAssets.flowerIcon,
                  ),
                ),
              ),
              label: const Text('About'),
            ),
          ),
        ),
      ],
    );
  }
}
