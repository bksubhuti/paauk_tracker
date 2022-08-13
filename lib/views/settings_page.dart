//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:paauk_tracker/src/models/select_language_widget.dart';
import 'package:paauk_tracker/src/models/select_theme_widget.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';
import 'package:paauk_tracker/src/models/change_theme_widget.dart';
import 'package:paauk_tracker/src/services/get_resident_details.dart';

import 'package:paauk_tracker/views/admin_view.dart';

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
            const SizedBox(height: 20),
            SizedBox(
              width: 450,
              height: 350,
              child: Stack(
                children: [
                  const SizedBox(height: 90),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Transform.scale(
                            scale: 5.5,
                            child: Switch(
                                //title: const Text('Sayadaw'),
                                activeThumbImage: const AssetImage(
                                    'assets/pa_auk_sayadawgyi.png'),
                                inactiveThumbImage: const AssetImage(
                                    'assets/sayadaw_kumarabhivamsa.png'),
                                value: Prefs.sayadawgyi,
                                onChanged: (bool value) {
                                  setState(() {
                                    Prefs.sayadawgyi = value;
                                  });
                                })),
                        const SizedBox(height: 50),
                        FloatingActionButton.extended(
                          label: const Text('Admin Screen'),
                          icon: const Icon(Icons.app_registration),
                          backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AdminView()),
                            );
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  _locked == true
                      ? Container(
                          width: 500,
                          height: 500,
                          padding: const EdgeInsets.all(5.0),
                          alignment: Alignment.bottomCenter,
                          color: Colors.black,
                          child: const Text(
                            'Locked',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ))
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
