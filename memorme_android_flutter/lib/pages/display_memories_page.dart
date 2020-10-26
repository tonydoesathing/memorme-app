import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/models/memory.dart';
import 'package:memorme_android_flutter/pages/display_memory_page.dart';
import 'package:memorme_android_flutter/widgets/memories_grid.dart';
import 'package:memorme_android_flutter/widgets/memories_list.dart';
import 'package:memorme_android_flutter/widgets/memory_display.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DisplayMemoriesPage extends StatefulWidget {
  final bool testing;
  final bool listView;
  final List<Memory> memories;
  final int focusedIndex;

  DisplayMemoriesPage(
      {Key key, this.testing = false, this.listView = false, this.memories, this.focusedIndex = 0})
      : super(key: key);

  @override
  _DisplayMemoriesPageState createState() => _DisplayMemoriesPageState();
}

class _DisplayMemoriesPageState extends State<DisplayMemoriesPage> {
  List<Memory> _memories;
  final ItemScrollController _scrollController = ItemScrollController();

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
    WidgetsBinding.instance.addPostFrameCallback((_) => executeAfterWholeBuildProcess(context));
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
          body: widget.listView
              ? MemoriesList(memories: _memories, scrollController: _scrollController)
              : MemoriesGrid(
                  memories: _memories,
                ),
      
        );
      }
      // jumps to correct index in list after build
      executeAfterWholeBuildProcess(BuildContext context) {
        _scrollController.jumpTo(index: widget.focusedIndex);

      }
}
