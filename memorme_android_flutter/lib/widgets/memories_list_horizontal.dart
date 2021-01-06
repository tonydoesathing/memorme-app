import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'memory_display.dart';

/*
* Horizontally slide between memories. Should somehow lower left/right scroll sensitivity such that a very purposeful swipe switches memory display
*/

class MemoriesList extends StatelessWidget {
  final List<Memory> memories;
  final int focusedIndex;
  final PageController pageController = PageController();

  MemoriesList(
      {Key key,
      List<Memory> memories,
      this.focusedIndex})
      : memories = memories ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //not sure if this is the best place for this function call
    //but basically allows scrolling to widget
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _executeAfterWholeBuildProcess(context));

    return PageView(
        controller: pageController,
        children: [
          for (Memory m in memories) ListView(children: [MemoryDisplay(m)],)
        ],
    );
  }

  //to be called internally; scrolls to element if needed
  _executeAfterWholeBuildProcess(BuildContext context) {
    if (this.memories.length > 0 && focusedIndex != null) {
      pageController.jumpToPage(focusedIndex);
    }
  }
}