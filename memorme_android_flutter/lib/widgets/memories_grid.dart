import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memory.dart';

class MemoriesGrid extends StatelessWidget {
  final List<Memory> memories;
  final void Function(Memory memory, int index) onTileTap;
  const MemoriesGrid({Key key, List<Memory> memories, this.onTileTap})
      : memories = memories ?? const [],
        super(key: key);

  // Return memories as grid tiles
  List<Widget> getMemoryTiles(BuildContext context) {
    List<Widget> tiles = <Widget>[];
    for (int i = 0; i < memories.length; i++) {
      tiles.add(GridTile(
          child: GestureDetector(
        onTap: () {
          //on tile tap, if callback passed in, call it
          this.onTileTap?.call(memories[i], i);
        },
        child: Container(
          color: Colors.blue,
          child: Image.file(
              File(
                memories[i].media[0],
              ),
              fit: BoxFit.cover),
        ),
      )));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 3),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          children: getMemoryTiles(context),
        ));
  }
}
