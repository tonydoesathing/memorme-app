import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/pages/edit_memory_page.dart';
import 'package:memorme_android_flutter/widgets/story_items/picture_story_item.dart';
import 'package:memorme_android_flutter/widgets/story_items/text_story_item.dart';

class MemoryDisplay extends StatelessWidget {
  final Memory memory;

  const MemoryDisplay(this.memory, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
                DateTime.fromMillisecondsSinceEpoch(memory.dateLastEdited)
                    .toIso8601String()),
            trailing: IconButton(
                icon: Icon(Icons.more_vert, color: Theme.of(context).accentColor),
                onPressed: () {
                  // maybe make use of https://pub.dev/packages/modal_bottom_sheet
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 200,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.edit, color: Theme.of(context).accentColor),
                              title: Text("Edit Memory", style: TextStyle(color: Theme.of(context).accentColor)),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/edit_memory',
                                    arguments:
                                        EditMemoryArguments(memory: memory));
                              },
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
          Divider(),
          for (Story s in memory.stories)
            s.type == StoryType.TEXT_STORY
                ? Padding(padding: EdgeInsets.all(10), child: TextStoryItem(s))
                : Padding(
                    padding: EdgeInsets.all(10), child: PictureStoryItem(s))
        ],
      )),
    );
  }
}
