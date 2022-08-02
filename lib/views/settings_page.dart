//import 'dart:ffi';

import 'package:paauk_tracker/src/models/resident_details.dart';
import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paauk_tracker/src/models/select_language_widget.dart';
import 'package:paauk_tracker/src/models/select_theme_widget.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';
import 'package:paauk_tracker/src/models/change_theme_widget.dart';
import 'package:paauk_tracker/src/services/database_helper.dart';

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

  _addSafetyItemsToMemberList() {
    if (_safetyItems.isEmpty) {
      _safetyItems.add(AppLocalizations.of(context)!.none);
      _safetyItems.add(AppLocalizations.of(context)!.minute1);
      _safetyItems.add(AppLocalizations.of(context)!.minutes2);
      _safetyItems.add(AppLocalizations.of(context)!.minutes3);
      _safetyItems.add(AppLocalizations.of(context)!.minutes4);
      _safetyItems.add(AppLocalizations.of(context)!.minutes5);
      _safetyItems.add(AppLocalizations.of(context)!.minutes10);
    }
  }

  _addKutiGroupItemsToMemberList() {
    if (_kutiGroupItems.isEmpty) {
      _kutiGroupItems.add("A");
      _kutiGroupItems.add("B");
      _kutiGroupItems.add("C");
      _kutiGroupItems.add("D");
      _kutiGroupItems.add("E");
      _kutiGroupItems.add("F");
      _kutiGroupItems.add("G");
      _kutiGroupItems.add("H");
      _kutiGroupItems.add("I");
      _kutiGroupItems.add("J");
      _kutiGroupItems.add("K");
      _kutiGroupItems.add("L");
      _kutiGroupItems.add("M");
      _kutiGroupItems.add("4");
      _kutiGroupItems.add("2");
      _kutiGroupItems.add("AKK");
      _kutiGroupItems.add("GL");
      _kutiGroupItems.add("ILBC");
      _kutiGroupItems.add("TL");
      _kutiGroupItems.add("TTW");
    }
  }

  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
// here we must add the localized values to the menu buttons.
// when we have an active context.
    _addSafetyItemsToMemberList();
    _addKutiGroupItemsToMemberList();

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
            const SizedBox(height: 25),
            const SizedBox(
              height: 10,
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  children: [
                    const SizedBox(height: 6.0),
                    const ColoredText("Kuti Group:",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    const SizedBox(
                      width: 10.0,
                      height: 20,
                    ),
                    DropdownButton<String>(
                        value: _kutiGroup,
                        style: TextStyle(
                          color: (Prefs.lightThemeOn)
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                        ),
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            _kutiGroup = newValue!;
                            searchKey = newValue;

                            //                                _dawnMethodItems.indexOf(newValue!);
                          });
                        },
                        items: _kutiGroupItems.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: ColoredText(
                                value,
                                style: TextStyle(
                                    color: (Prefs.lightThemeOn)
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ).toList()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              style: TextStyle(
                  color: (Prefs.lightThemeOn)
                      ? Theme.of(context).primaryColor
                      : null,
                  fontSize: 20),
              decoration: InputDecoration(
                  labelText: "Search For Kuti",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              controller: controller,
              onChanged: (String data) {
                setState(() {
                  searchKey = data;
                });
                //  print(data);
              },
            ),
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: FutureBuilder<List<ResidentDetails>>(
                  future: dbService.getResidentDetails(searchKey),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () async {
                                _showSignInDialog(
                                    snapshot.data![index].dhamma_name,
                                    snapshot.data![index].kuti,
                                    snapshot.data![index].country);
                              }, // on tap
                              title: ColoredText(
                                  "${snapshot.data![index].kuti}, ${snapshot.data![index].country} ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: (Prefs.lightThemeOn)
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                  )),
                              subtitle: ColoredText(
                                  snapshot.data![index].dhamma_name +
                                      "," +
                                      snapshot.data![index].country),
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showSignInDialog(
      String name, String kuti, String country) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign In'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ColoredText(name,
                    style: TextStyle(
                      fontSize: 24,
                      color: (Prefs.lightThemeOn)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    )),
                ColoredText("Kuti = ${kuti} ",
                    style: TextStyle(
                      fontSize: 17,
                      color: (Prefs.lightThemeOn)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    )),
                ColoredText("${country} ",
                    style: TextStyle(
                      fontSize: 17,
                      color: (Prefs.lightThemeOn)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
