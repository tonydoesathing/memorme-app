import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';

class MemoriesGrid extends StatelessWidget {
  final List<Memory> memories;
  final void Function(Memory memory, int index) onTileTap;
  const MemoriesGrid({Key key, List<Memory> memories, this.onTileTap})
      : memories = memories ?? const [],
        super(key: key);

  Widget _getPreview(int memoryIndex){
    Story previewStory = memories[memoryIndex].stories[0];
    if (previewStory.type == StoryType.TEXT_STORY){
      return Container(
        child: Text(previewStory.data, style: TextStyle(color: Colors.blue, fontSize: 20))
      );
    }
    else if (previewStory.type == StoryType.PICTURE_STORY){
      return Container(
        color: Colors.blue,
        child: Image.file(File(previewStory.data),fit: BoxFit.cover)
      );
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
