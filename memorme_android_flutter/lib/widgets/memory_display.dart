import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/pages/edit_memory_page.dart';
import 'package:memorme_android_flutter/presentation/theme/memorme_colors.dart';
import 'package:memorme_android_flutter/widgets/story_items/picture_story_item.dart';
import 'package:memorme_android_flutter/widgets/story_items/text_story_item.dart';

class MemoryDisplay extends StatelessWidget {
  final void Function(Memory memory) onEditSave;

  final Memory memory;

  const MemoryDisplay(this.memory, {Key key, this.onEditSave})
      : super(key: key);

  parseTime(String datetime) {
    String date = datetime.split('T')[0];
    String time = datetime.split('T')[1];

    String year = date.split('-')[0];
    String month = date.split('-')[1];
    String day = date.split('-')[2];

    String hour = time.split(':')[0];
    String minute = time.split(':')[1];

    String parsed = month + "/" + day + "/" + year;
    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Column(
        children: <Widget>[
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    this.memory.title ??
                        parseTime(memory.dateLastEdited.toIso8601String()),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Positioned.fill(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(Icons.more_vert),
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
                                        leading: Icon(Icons.edit,
                                            color:
                                                Theme.of(context).primaryColor),
                                        title: Text("Edit Memory",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, '/edit_memory',
                                              arguments: EditMemoryArguments(
                                                  memory: memory,
                                                  onSave: this.onEditSave));
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                        }),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          for (Story s in memory.stories)
            if (s.type == StoryType.TEXT_STORY)
              Padding(padding: EdgeInsets.all(10), child: TextStoryItem(s))
            else if (s.type == StoryType.PICTURE_STORY)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: constraints.maxWidth),
                      child: Container(
                        //color: MemorMeColors.darkGrey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PictureStoryItem(s),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          Padding(padding: EdgeInsets.all(8.0))
        ],
      )),
    );
  }
}
