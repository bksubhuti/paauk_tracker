//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paauk_tracker/src/models/select_language_widget.dart';
import 'package:paauk_tracker/src/models/select_theme_widget.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';
import 'package:paauk_tracker/src/models/change_theme_widget.dart';
import 'package:paauk_tracker/src/models/resident_details.dart';
import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.goToHome}) : super(key: key);
  final VoidCallback goToHome;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final dbService = GetResidentDetails();
  String searchKey = "A";
  String _kutiGroup = 'AKK';

  final List<String> _safetyItems = <String>[];

  final List<String> _kutiGroupItems = <String>[];

  @override
  void initState() {
    // debug mode to reset
    //Prefs.instance.clear();
    super.initState();
  }

  @override
  void dispose() {
    //dbService.dispose();
    super.dispose();
  }

  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
// here we must add the localized values to the menu buttons.
// when we have an active context.

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              elevation: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColoredText(AppLocalizations.of(context)!.theme + ":",
                      style: const TextStyle(
                        fontSize: 12,
                      )),
                  const SizedBox(width: 4.0),
                  const SelectThemeWidget(),
                  const ChangeThemeWidget(),
                  //SizedBox(width: 8.0),
                  ColoredText(AppLocalizations.of(context)!.language + ":",
                      style: const TextStyle(
                        fontSize: 12,
                      )),
                  const SizedBox(width: 4.0),
                  SelectLanguageWidget(),
                ],
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: const Text('Share DB'),
              onPressed: () async {
                var databasePath = await getDatabasesPath();
                String path = join(databasePath, 'paauk_tracker.db');
                final List<String> sl = [path];
                final box = context.findRenderObject() as RenderBox?;

                await Share.shareFiles(sl,
                    text: "Share DB",
                    subject: "Pa-Auk Tracker",
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size);
              },
            ),
          ],
        ),
      ),
    );
  }
}
