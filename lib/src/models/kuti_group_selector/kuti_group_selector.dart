import 'package:flutter/material.dart';

import 'kuti_group_tile_widget.dart';

class KutiGroupSelector extends StatelessWidget {
  const KutiGroupSelector({Key? key,
    required List<String> kutiGroupItems,
    this.columnsCount = 5,
    this.onTap})
      : _kutiGroupItems = kutiGroupItems,
        super(key: key);

  final List<String> _kutiGroupItems;
  final int columnsCount;
  final Function(String)? onTap;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    const padding = 20;
    var availableWidth = screenWidth - 2 * padding;
    var width = availableWidth / columnsCount;
    return Wrap(
        children: _getTiles(width)
    );
  }

  List<Widget> _getTiles(width) {
    return _kutiGroupItems
        .map((String kutiGroup) =>
        KutiGroupTile(
          label: kutiGroup,
          width: width,
          onTap: () {
            onTap?.call(kutiGroup);
          },
        ))
        .toList();
  }
}
