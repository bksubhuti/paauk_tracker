import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';

Future showGpsPermissionInfoDialog(BuildContext context) async {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK",
        style: TextStyle(
          color: (Prefs.lightThemeOn)
              ? Theme.of(context).primaryColor
              : Colors.white,
        )),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog help = AlertDialog(
    title: Text(AppLocalizations.of(context)!.gps_permission),
    content: SingleChildScrollView(
      child: ColoredText(AppLocalizations.of(context)!.gps_permission_content,
          style: const TextStyle(fontSize: 16)),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return help;
    },
  );
}
