import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/models/memory.dart';
import 'package:memorme_android_flutter/pages/display_memories_page.dart';

class MemoriesGrid extends StatelessWidget {
  final List<Memory> memories;
  const MemoriesGrid({Key key, List<Memory> memories})
      : memories = memories ?? const [],
        super(key: key);

  // Return memories as grid tiles
  List<Widget> getMemoryTiles(BuildContext context){
    List<Widget> tiles = <Widget>[];
    for (int i = 0; i < memories.length; i++){
      tiles.add(GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext buildContext) =>
                    DisplayMemoriesPage(
                      listView: true,
                      memories: memories,
                      focusedIndex: i
                    )));
          },
          child: Container(
            color: Colors.blue,
            child: Image.file(
              File(memories[i].getMedia(0),
              ),
              fit: BoxFit.cover
            ),
          ),
        )
      ));
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
        )

      );
  }
}
