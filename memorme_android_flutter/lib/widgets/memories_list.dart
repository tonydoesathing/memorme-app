import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/models/memory.dart';

import 'memory_display.dart';

class MemoriesList extends StatelessWidget {
  final List<Memory> memories;
  const MemoriesList({Key key, List<Memory> memories})
      : memories = memories ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index < memories.length) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: MemoryDisplay(memories[index]),
          );
        }
      },
    );
  }
}

/*class MemoriesList extends StatefulWidget {
  final List<Memory> memories;

  MemoriesList({
    Key key,
    this.memories,
  }) : super(key: key);

  @override
  _MemoriesListState createState() => _MemoriesListState();
}

class _MemoriesListState extends State<MemoriesList> {
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
}
*/
