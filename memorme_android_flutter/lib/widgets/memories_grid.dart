
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/widgets/story_previews/picture_story_preview.dart';
import 'package:memorme_android_flutter/widgets/story_previews/text_story_preview.dart';

class MemoriesGrid extends StatelessWidget {
  final List<Memory> memories;
  final void Function(Memory memory, int index) onTileTap;
  const MemoriesGrid({Key key, List<Memory> memories, this.onTileTap})
      : memories = memories ?? const [],
        super(key: key);

  /// from the memory at [memoryIndex], return its preview
  Widget _getPreview(int memoryIndex){
    Story previewStory = memories[memoryIndex].stories[0]; // the default preview is currenly the first story in the memory
    if (previewStory.type == StoryType.TEXT_STORY){
      return TextStoryPreview(previewStory);
    }
    else if (previewStory.type == StoryType.PICTURE_STORY){
      return PictureStoryPreview(previewStory);
    }
    return Container(child: Text("Need to implement a preview for this story type"));
  }

  // Return memories as grid tiles
  List<Widget> getMemoryTiles(BuildContext context) {
    List<Widget> tiles = <Widget>[];
    for (int i = 0; i < memories.length; i++) {
      tiles.add(GridTile(
          child: GestureDetector(
        onTap: () {
          //on tile tap, if callback passed in, call it
          this.onTileTap?.call(memories[i], i);
        },
        child: _getPreview(i)
      )));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 3),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          children: getMemoryTiles(context),
        ));
  }
}
