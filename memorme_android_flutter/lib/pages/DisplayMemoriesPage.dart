import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/models/memory.dart';
import 'package:memorme_android_flutter/pages/DisplayMemoryPage.dart';

class DisplayMemoriesPage extends StatefulWidget {
  final bool testing;
  DisplayMemoriesPage({Key key, this.testing = false}) : super(key: key);

  @override
  _DisplayMemoriesPageState createState() => _DisplayMemoriesPageState();
}

class _DisplayMemoriesPageState extends State<DisplayMemoriesPage> {
  List<Memory> memories;

  @override
  void initState() {
    super.initState();
    memories = [];
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
              memories.add(memory);
            });
          } else {
            //display memory UI
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayMemoryPage(
                          onSave: (memory) {
                            setState(() {
                              memories.add(memory);
                            });
                          },
                        )));
          }
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        if (index < memories.length) {
          return GestureDetector(
            key: Key("MemoriesListTile"),
            onTap: () {},
            child: ListTile(
              title: Text(memories[index].getStory(0)),
            ),
          );
        }
      }),
    );
  }
}
