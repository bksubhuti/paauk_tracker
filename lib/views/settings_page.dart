//import 'dart:ffi';

import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paauk_tracker/src/models/select_language_widget.dart';
import 'package:paauk_tracker/src/models/select_theme_widget.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';
import 'package:paauk_tracker/src/models/change_theme_widget.dart';
import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'package:share_plus/share_plus.dart';
import 'package:paauk_tracker/src/services/interview_queries.dart';
import 'package:paauk_tracker/src/models/interview_details.dart';

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
  bool _locked = true;

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
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Share CSV'),
              onPressed: () async {
                _writeCSVFile();
                var databasePath = await getDatabasesPath();
                String path = join(databasePath, 'paauk_tracker.csv');
                final List<String> sl = [path];
                final box = context.findRenderObject() as RenderBox?;

                await Share.shareFiles(sl,
                    text: "Share DB",
                    subject: "Pa-Auk Tracker",
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size);
              },
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              obscureText: true,
              style: TextStyle(
                  color: (Prefs.lightThemeOn)
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  fontSize: 15),
              decoration: const InputDecoration(
                  labelText: "Pin Code", border: OutlineInputBorder()),
              onChanged: (String data) async {
                setState(() {
                  Prefs.locked = (data != "5656");
                  _locked = Prefs.locked;
                });
              },
            ),
            const SizedBox(height: 90),
            _locked == true
                ? const Text("locked")
                : Transform.scale(
                    scale: 5.5,
                    child: Switch(
                        //title: const Text('Sayadaw'),
                        activeThumbImage:
                            const AssetImage('assets/pa_auk_sayadawgyi.png'),
                        inactiveThumbImage: const AssetImage(
                            'assets/sayadaw_kumarabhivamsa.png'),
                        value: Prefs.sayadawgyi,
                        onChanged: (bool value) {
                          setState(() {
                            Prefs.sayadawgyi = value;
                          });
                        })),
          ],
        ),
      ),
    );
  }

  Future _writeCSVFile() async {
    final dbService = InterviewQueries();
    String csv = "id_code\tteacher\tstime\treal_time\n";
    List<InterviewDetails> rows = await dbService.getAllInterviewDetails();

    for (int i = 0; i < rows.length; i++) {
      csv +=
          "${rows[i].id_code}\t${rows[i].teacher}\t${rows[i].stime}\t${rows[i].real_time}\n";
    }

    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'paauk_tracker.csv');

    File f = File(path);
    //String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
  }
}
