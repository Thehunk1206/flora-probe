import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '../../commons/string_const.dart';
import '../../commons/styles.dart';

import 'license.dart';

void showMyAboutDialog({
  required BuildContext context,
  String? applicationName,
  String? applicationVersion,
  Widget? applicationIcon,
  String? applicationLegalese,
  List<Widget>? children,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  showDialog<void>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return AboutDialog(
        applicationVersion: applicationVersion,
        applicationIcon: applicationIcon,
        applicationLegalese: applicationLegalese,
        children: children,
      );
    },
    routeSettings: routeSettings,
  );
}

class AboutDialog extends StatelessWidget {
  /// Creates an about box.
  ///
  /// The arguments are all optional. The application name, if omitted, will be
  /// derived from the nearest [Title] widget. The version, icon, and legalese
  /// values default to the empty string.
  const AboutDialog({
    super.key,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
    this.children,
  });

  /// The version of this build of the application.
  ///
  /// This string is shown under the application name.
  ///
  /// Defaults to the empty string.
  final String? applicationVersion;

  /// The icon to show next to the application name.
  ///
  /// By default no icon is shown.
  ///
  /// Typically this will be an [ImageIcon] widget. It should honor the
  /// [IconTheme]'s [IconThemeData.size].
  final Widget? applicationIcon;

  /// A string to show in small print.
  ///
  /// Typically this is a copyright notice.
  ///
  /// Defaults to the empty string.
  final String? applicationLegalese;

  /// Widgets to add to the dialog box after the name, version, and legalese.
  ///
  /// This could include a link to a Web site, some descriptive text, credits,
  /// or other information to show in the about box.
  ///
  /// Defaults to nothing.
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    // final String name = Strings.title;
    final String? version = applicationVersion;
    final Widget? icon = applicationIcon;
    final TextStyle? outlineButtonTextStyle =
        Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 12,
            );
    // TODO(predatorx7) check AlertDialog's scrollable true
    return Dialog(
      backgroundColor: Colors.lightGreen[100],
      shape: const RoundedRectangleBorder(borderRadius: Corners.borderRadius),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(EvaIcons.close),
                tooltip: 'close',
                onPressed: () => Navigator.of(context).maybePop(),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: ListBody(
              children: <Widget>[
                if (icon != null)
                  IconTheme(data: Theme.of(context).iconTheme, child: icon),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 8),
                  child: RichText(
                    text: TextSpan(
                      text: 'version ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.green),
                      children: [
                        TextSpan(
                          text: version,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                ...?children,
                const SizedBox(
                  height: 10,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                //   child: ListBody(
                //     children: <Widget>[
                //       Container(height: 18.0),
                //       Text(
                //         Strings.applicationLegalese ?? '',
                //         style: Theme.of(context).textTheme.caption,
                //         textAlign: TextAlign.left,
                //       ),
                //     ],
                //   ),
                // ),
                Tooltip(
                  message: 'Contact us',
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: Corners.outlinedShapeBorder,
                    ),
                    onPressed: () {
                      print('Contact us');
                    },
                    child: Text(
                      Strings.contactUs,
                      style: outlineButtonTextStyle,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'View licenses',
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: Corners.outlinedShapeBorder,
                    ),
                    child: Text(
                      Strings.viewLicenses,
                      style: outlineButtonTextStyle,
                    ),
                    onPressed: () {
                      showMyLicensePage(
                        context: context,
                        applicationName: '',
                        applicationVersion: applicationVersion,
                        applicationIcon: applicationIcon,
                        applicationLegalese: applicationLegalese,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
