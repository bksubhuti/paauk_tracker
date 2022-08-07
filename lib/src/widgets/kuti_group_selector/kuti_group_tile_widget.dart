import 'package:flutter/material.dart';

import 'package:paauk_tracker/src/models/colored_text.dart';

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
              highlightColor: Theme.of(context).highlightColor,
              splashColor: Theme.of(context).primaryColor,
              onTap: onTap,
              radius: 22,
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                color: const Color.fromARGB(255, 247, 232, 235),
                child: ColoredText(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
        ));
  }
}
