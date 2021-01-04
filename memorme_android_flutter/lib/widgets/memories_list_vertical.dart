import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'memory_display.dart';

/*
* Vertically slide between memories. Extremely buggy. Destroy with fire
*/

class MemoriesList extends StatelessWidget {
  final List<Memory> memories;
  final int focusedIndex;

  PageController _pageController = PageController();
  List<ScrollController> listScrollController;
  ScrollController _activeScrollController;
  int currentIndex;
  ScrollController currentListScrollController;
  Drag _drag;

  MemoriesList(
      {Key key,
      List<Memory> memories,
      this.focusedIndex})
      : memories = memories ?? const [], this.listScrollController = List<ScrollController>.generate(memories.length, (index) => ScrollController()), currentIndex = focusedIndex,
        super(key: key);


  void _handleDragStart(DragStartDetails details) {
    if (listScrollController[currentIndex].hasClients && listScrollController[currentIndex].position.context.storageContext != null) {
      final RenderBox renderBox = listScrollController[currentIndex].position.context.storageContext.findRenderObject();
      if (renderBox.paintBounds.shift(renderBox.localToGlobal(Offset.zero)).contains(details.globalPosition)) {
        _activeScrollController = listScrollController[currentIndex];
        _drag = _activeScrollController.position.drag(details, _disposeDrag);
        return;
      }
    }
    _activeScrollController = _pageController;
    //currentIndex = pageController.page.toInt();
    _drag = _pageController.position.drag(details, _disposeDrag);
    currentIndex = _pageController.page.toInt();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_activeScrollController == listScrollController[currentIndex] && details.primaryDelta < 0 && _activeScrollController.position.pixels == _activeScrollController.position.maxScrollExtent) {
      _activeScrollController = _pageController;
      _drag?.cancel();
      _drag = _pageController.position.drag(
        DragStartDetails(
          globalPosition: details.globalPosition,
          localPosition: details.localPosition
        ),
        _disposeDrag
      );
    }
    _drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    _drag?.end(details);
  }

  void _handleDragCancel() {
    _drag?.cancel();
  }

  void _disposeDrag() {
    _drag = null;
  }

  @override
  Widget build(BuildContext context) {
    //not sure if this is the best place for this function call
    //but basically allows scrolling to widget
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _executeAfterWholeBuildProcess(context));

    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
          VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
          (VerticalDragGestureRecognizer instance) {
            instance
              ..onStart = _handleDragStart
              ..onUpdate = _handleDragUpdate
              ..onEnd = _handleDragEnd
              ..onCancel = _handleDragCancel;
          }
          )
      },
      behavior: HitTestBehavior.opaque,
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        children: [

          for (Memory m in memories) ListView(controller: listScrollController[currentIndex], physics: const NeverScrollableScrollPhysics(), children: [MemoryDisplay(m)],)
        ],
      )
    );
  }

  //to be called internally; scrolls to element if needed
  _executeAfterWholeBuildProcess(BuildContext context) {
    if (this.memories.length > 0 && focusedIndex != null) {
      _pageController.jumpToPage(focusedIndex);
    }
  }
}