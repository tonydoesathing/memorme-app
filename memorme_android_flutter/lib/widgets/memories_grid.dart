import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/models/memory.dart';
import 'package:memorme_android_flutter/pages/display_memories_page.dart';

class MemoriesGrid extends StatefulWidget {
  final List<Memory> memories;

  MemoriesGrid({Key key, this.memories}) : super(key: key);

  @override
  _MemoriesGridState createState() => _MemoriesGridState();
}

class _MemoriesGridState extends State<MemoriesGrid> {
  List<Memory> _memories;

  @override
  void initState() {
    super.initState();
    if (widget.memories == null) {
      _memories = [];
    } else {
      _memories = widget.memories;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 3),
        child: GridView.builder(
            itemCount: _memories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 3, crossAxisSpacing: 3),
            itemBuilder: (BuildContext context, int index) {
              if (index < _memories.length) {
                return GestureDetector(
                  key: Key("MemoriesGridTile"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext buildContext) =>
                            DisplayMemoriesPage(
                              listView: true,
                              memories: _memories,
                            )));
                  },
                  child: Container(
                    color: Colors.blue,
                    child: Image.file(
                      File(_memories[index].getMedia(0)),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            }));
  }
}
