import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/models/memory.dart';
import 'package:memorme_android_flutter/pages/display_memory_page.dart';
import 'package:memorme_android_flutter/widgets/memories_grid.dart';
import 'package:memorme_android_flutter/widgets/memories_list.dart';
import 'package:memorme_android_flutter/widgets/memory_display.dart';

class DisplayMemoriesPage extends StatefulWidget {
  final bool testing;
  final bool listView;
  final List<Memory> memories;
  DisplayMemoriesPage(
      {Key key, this.testing = false, this.listView = false, this.memories})
      : super(key: key);

  @override
  _DisplayMemoriesPageState createState() => _DisplayMemoriesPageState();
}

class _DisplayMemoriesPageState extends State<DisplayMemoriesPage> {
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Memories"),
        ),
        floatingActionButton: FloatingActionButton(
          key: Key("AddMemoryFAB"),
          onPressed: () {
            if (widget.testing) {
              setState(() {
                Memory memory = Memory();
                memory.addStory("story");
                _memories.add(memory);
              });
            } else {
              //display memory UI
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayMemoryPage(
                            onSave: (memory) {
                              setState(() {
                                _memories.add(memory);
                              });
                            },
                          )));
            }
          },
          child: Icon(Icons.add),
        ),
        body:
            /*widget.listView
          ? MemoriesList(memories: _memories)
          : MemoriesGrid(
              memories: _memories,
            ),*/
            MemoriesGrid(
          memories: _memories,
        ));
  }
}
