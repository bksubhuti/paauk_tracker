import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/prefs.dart';

import '../colored_text.dart';

class KutiGroupTile extends StatelessWidget {
  const KutiGroupTile(
      {Key? key, required this.label, required this.width, this.onTap})
      : super(key: key);

  final String label;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        width: width,
        height: 30,
        child: Card(
          child: InkWell(
              onTap: onTap,
              child: Center(
                child: ColoredText(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: (Prefs.lightThemeOn)
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
        ));
  }
}
