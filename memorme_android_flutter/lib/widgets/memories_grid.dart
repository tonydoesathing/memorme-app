import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/widgets/memory/memory_preview.dart';
import 'package:memorme_android_flutter/widgets/story_previews/picture_story_preview.dart';
import 'package:memorme_android_flutter/widgets/story_previews/text_story_preview.dart';

/// Displays a grid of [Memory] from a provided list of [Memories]
///
/// Takes optional callbacks for [onTileTap] and [onScrollHit]
/// [onTileTap] is when a grid tile is tapped
/// [onScrollHit] is when the user scrolls to 200 pixels above the bottom
class MemoriesGrid extends StatefulWidget {
  final List<Memory> memories;
  final void Function(Memory memory, int index) onTileTap;
  final void Function() onScrollHit;
  final bool Function() shouldCheckScroll;
  const MemoriesGrid(
      {Key key,
      List<Memory> memories,
      this.onTileTap,
      this.onScrollHit,
      this.shouldCheckScroll})
      : memories = memories ?? const [],
        super(key: key);

  @override
  _MemoriesGridState createState() => _MemoriesGridState();
}

class _MemoriesGridState extends State<MemoriesGrid> {
  ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (widget.shouldCheckScroll == null || widget.shouldCheckScroll()) {
        print("checking scroll");
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        if (maxScroll - currentScroll <= _scrollThreshold) {
          if (widget.onScrollHit != null) {
            widget.onScrollHit.call();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 3),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.memories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
              childAspectRatio: 0.85),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  //on tile tap, if callback passed in, call it
                  this.widget.onTileTap?.call(widget.memories[index], index);
                },
                child: MemoryPreview(memory: widget.memories[index]));
          },
          controller: _scrollController,
        ));
  }
}
