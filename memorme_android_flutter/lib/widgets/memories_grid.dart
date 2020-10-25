import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/models/memory.dart';
import 'package:memorme_android_flutter/pages/display_memories_page.dart';

class MemoriesGrid extends StatelessWidget {
  final List<Memory> memories;
  const MemoriesGrid({Key key, List<Memory> memories})
      : memories = memories ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 3),
        child: GridView.builder(
            itemCount: memories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 3, crossAxisSpacing: 3),
            itemBuilder: (BuildContext context, int index) {
              if (index < memories.length) {
                return GestureDetector(
                  key: Key("MemoriesGridTile"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext buildContext) =>
                            DisplayMemoriesPage(
                              listView: true,
                              memories: memories,
                            )));
                  },
                  child: Container(
                    color: Colors.blue,
                    child: Image.file(
                      File(memories[index].getMedia(0)),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            }));
  }
}
