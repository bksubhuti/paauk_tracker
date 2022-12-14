import 'package:paauk_tracker/src/provider/locale_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';

class SelectLanguageWidget extends StatelessWidget {
  SelectLanguageWidget({Key? key}) : super(key: key);
  final _languageItmes = <String>[
    'English',
    'မြန်မာ',
    'සිංහල',
    '中文',
    'Tiếng Việt'
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: _languageItmes[Prefs.localeVal],
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        isDense: true,
        onChanged: (newValue) {
          Prefs.localeVal = _languageItmes.indexOf(newValue!);
          final localeProvider =
              Provider.of<LocaleChangeNotifier>(context, listen: false);
          localeProvider.localeVal = Prefs.localeVal;
        },
        items: _languageItmes.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: ColoredText(
                value,
                style: TextStyle(
                    color: (Prefs.lightThemeOn)
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            );
          },
        ).toList());
  }
}
