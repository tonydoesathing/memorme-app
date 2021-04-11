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
  final Future<Memory> Function(Memory memory) deleteMemory;

  final Memory memory;

  const MemoryDisplay(this.memory,
      {Key key, this.onEditSave, this.deleteMemory})
      : super(key: key);

  String dateFormat(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
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
                    this.memory.title ?? dateFormat(memory.dateLastEdited),
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
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.delete_forever,
                                            color:
                                                Theme.of(context).errorColor),
                                        title: Text("Delete Memory",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor)),
                                        onTap: () {
                                          Navigator.pop(context);
                                          if (deleteMemory != null) {
                                            showDialog<bool>(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'This will delete the memory forever.\nContinue?'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Yes'),
                                                      onPressed: () async {
                                                        // discard the collection

                                                        await deleteMemory(
                                                            memory);
                                                        // close the dialog and allow it to pop
                                                        Navigator.pop(
                                                            context, true);
                                                        Navigator.pop(
                                                            context, true);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text('No'),
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, false);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
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
                      constraints: BoxConstraints(
                          maxHeight: constraints.maxWidth,
                          maxWidth: constraints.maxWidth),
                      child: Container(
                        //color: MemorMeColors.darkGrey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: PictureStoryItem(s)),
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
