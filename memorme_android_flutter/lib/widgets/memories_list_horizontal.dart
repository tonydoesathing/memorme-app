
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'memory_display.dart';

/*
* Horizontally slide between memories
*/

/// modification of page scroll physics that lowers scroll sensitivity
/// by increasing drag start distance
class LowSensitivityScrollPhysics extends PageScrollPhysics {

  const LowSensitivityScrollPhysics({ScrollPhysics parent}) 
      : super(parent: parent);

  @override
  double get dragStartDistanceMotionThreshold => 40;

  @override
  LowSensitivityScrollPhysics applyTo(ScrollPhysics ancestor) {
    return LowSensitivityScrollPhysics(parent: buildParent(ancestor));
  }
}


/// displays a list of [memories] that jumps to [focusedIndex]
/// with sensitivity determined by [physics]
class MemoriesList extends StatelessWidget {
  final List<Memory> memories;
  final int focusedIndex;
  final PageController pageController;
  final ScrollPhysics physics = LowSensitivityScrollPhysics();

  MemoriesList(
      {Key key,
      List<Memory> memories,
      this.focusedIndex})
      : memories = memories ?? const [],
        this.pageController = PageController(initialPage: focusedIndex),
        super(key: key);

  @override
  Widget build(BuildContext context) {

    return PageView(
        physics: physics,
        controller: pageController,
        children: [
          for (Memory m in memories) ListView(children: [MemoryDisplay(m)],)
        ],
    );
  }
}