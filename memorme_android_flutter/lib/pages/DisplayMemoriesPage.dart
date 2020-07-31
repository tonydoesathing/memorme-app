import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/models/memory.dart';
import 'package:memorme_android_flutter/pages/DisplayMemoryPage.dart';
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

  Widget _memoriesGrid() {
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
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (BuildContext buildContext) =>
                    //         DisplayMemoriesPage(
                    //           testing: widget.testing,
                    //           listView: true,
                    //           memories: _memories,
                    //         )));
                  },
                  child: Container(
                    color: Colors.blue,
                    child: widget.testing
                        ? Text("meow")
                        : Image.file(
                            File(_memories[index].getMedia(0)),
                            fit: BoxFit.cover,
                          ),
                  ),
                );
              }
            }));
  }

  Widget _memoriesList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index < _memories.length) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: MemoryDisplay(_memories[index]),
          );
        }
      },
    );
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
      body: //widget.listView ? _memoriesList() : _memoriesGrid(),
          _memoriesGrid(),
    );
  }
}
