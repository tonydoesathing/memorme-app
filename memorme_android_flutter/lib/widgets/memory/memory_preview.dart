import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/widgets/memory/inner_shadow.dart';

/// A preview for a [Memory]
class MemoryPreview extends StatelessWidget {
  final Memory memory;
  const MemoryPreview({Key key, @required this.memory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
          elevation: 3.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: InnerShadow(
                    color: Colors.black.withOpacity(0.15),
                    blur: 2.0,
                    offset: Offset(2.0, 2.0),
                    child: InnerShadow(
                      color: Colors.black.withOpacity(0.15),
                      blur: 2.0,
                      offset: Offset(-2.0, -2.0),
                      child: Container(
                          color: Colors.white,
                          child: Builder(
                            builder: (context) {
                              // check to see if we have any Stories
                              if (memory?.stories == null ||
                                  memory.stories.length == 0) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    "No stories in memory",
                                    textAlign: TextAlign.center,
                                  )),
                                );
                              }
                              // check to see if there's a defined preview story
                              // otherwise, pick the first story
                              Story previewStory =
                                  memory.previewStory ?? memory.stories.first;

                              // build the appropriate preview depending on the story
                              if (previewStory.type == StoryType.TEXT_STORY) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    previewStory.data ?? "",
                                    overflow: TextOverflow.fade,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                );
                              } else if (previewStory.type ==
                                  StoryType.PICTURE_STORY) {
                                return Image.file(
                                  File(previewStory.data),
                                  fit: BoxFit.cover,
                                );
                              }

                              // shit something failed
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  "Could not load story",
                                  textAlign: TextAlign.center,
                                )),
                              );
                            },
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 2.0, right: 2.0),
                  child: Center(
                    child: Text(
                      memory?.title ?? "",
                      style: Theme.of(context).textTheme.headline6,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
