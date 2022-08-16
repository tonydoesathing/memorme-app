import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';

/// Makes a preview for a given [textStory]
class TextStoryPreview extends StatelessWidget {
  final Story textStory;

  const TextStoryPreview(this.textStory, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        textStory.data,
        maxLines: 6,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 14),
      ),
    ));
  }
}
