import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'memory_display.dart';

class MemoriesListArguments {
  final int focusedIndex;

  MemoriesListArguments(this.focusedIndex);
}

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
class MemoriesList extends StatefulWidget {
  final List<Memory> memories;
  final int focusedIndex;

  /// takes an [index] and a [max]
  final Function(int index, int max) onPageChanged;

  MemoriesList(
      {Key key, List<Memory> memories, this.focusedIndex, this.onPageChanged})
      : memories = memories ?? const [],
        super(key: key);

  @override
  _MemoriesListState createState() => _MemoriesListState();
}

class _MemoriesListState extends State<MemoriesList> {
  final ScrollPhysics physics = LowSensitivityScrollPhysics();
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.focusedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: physics,
      controller: pageController,
      itemCount: widget.memories.length,
      itemBuilder: (context, index) {
        return ListView(
          children: [MemoryDisplay(widget.memories[index])],
        );
      },
      onPageChanged: (index) => this.widget.onPageChanged == null
          ? null
          : this.widget.onPageChanged.call(index, widget.memories.length),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
