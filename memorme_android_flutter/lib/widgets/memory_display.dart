
import 'package:flutter/widgets.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/widgets/story_items/picture_story_item.dart';
import 'package:memorme_android_flutter/widgets/story_items/text_story_item.dart';

class MemoryDisplay extends StatelessWidget  {

  final Memory memory;

  const MemoryDisplay(this.memory, {Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        for (Story s in memory.stories) s.type == StoryType.TEXT_STORY ? Padding(padding: EdgeInsets.all(10), child: TextStoryItem(s)) : Padding(padding: EdgeInsets.all(10), child: PictureStoryItem(s))
      ],
    );
  }
}