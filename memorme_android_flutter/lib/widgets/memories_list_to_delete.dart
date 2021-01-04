import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'memory_display.dart';

class MemoriesList extends StatelessWidget {
  final List<Memory> memories;
  final ItemScrollController _scrollController = ItemScrollController();
  final int focusedIndex;

  MemoriesList(
      {Key key,
      List<Memory> memories,
      ItemScrollController scrollController,
      this.focusedIndex})
      : memories = memories ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //not sure if this is the best place for this function call
    //but basically allows scrolling to widget
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _executeAfterWholeBuildProcess(context));

    //create list
    return ScrollablePositionedList.builder(
        itemCount: memories.length,
        itemScrollController: _scrollController,
        itemBuilder: (context, index) => MemoryDisplay(memories[index]));
  }

  //to be called internally; scrolls to element if needed
  _executeAfterWholeBuildProcess(BuildContext context) {
    if (this.memories.length > 0 && focusedIndex != null) {
      _scrollController.jumpTo(index: focusedIndex);
    }
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
