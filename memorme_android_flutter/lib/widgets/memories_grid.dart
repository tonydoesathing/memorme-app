import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
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
  const MemoriesGrid(
      {Key key, List<Memory> memories, this.onTileTap, this.onScrollHit})
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
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        if (widget.onScrollHit != null) {
          widget.onScrollHit.call();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// from the memory at [memoryIndex], return its preview
  Widget _getPreview(int memoryIndex) {
    Story previewStory = widget.memories[memoryIndex].stories[
        0]; // the default preview is currenly the first story in the memory
    if (previewStory.type == StoryType.TEXT_STORY) {
      return TextStoryPreview(previewStory);
    } else if (previewStory.type == StoryType.PICTURE_STORY) {
      return PictureStoryPreview(previewStory);
    }
    return Container(
        child: Text("Need to implement a preview for this story type"));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 3),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.memories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 3, crossAxisSpacing: 3),
          itemBuilder: (context, index) {
            return GridTile(
                child: GestureDetector(
                    onTap: () {
                      //on tile tap, if callback passed in, call it
                      this
                          .widget
                          .onTileTap
                          ?.call(widget.memories[index], index);
                    },
                    child: _getPreview(index)));
          },
          controller: _scrollController,
        ));
  }
}
