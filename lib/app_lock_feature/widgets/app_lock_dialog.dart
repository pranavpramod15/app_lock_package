import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAppLockDialog({
  required BuildContext context,
  required String errorTitle,
  required String errorMessage,
}) {
  showCupertinoDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: CupertinoAlertDialog(
          title: Center(
              child: Text(
            errorTitle,
          )),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Settings"),
              onPressed: () {
                AppSettings.openAppSettings(
                    type: AppSettingsType.security,
                    asAnotherTask: Platform.isAndroid ? true : false);

                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
