import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';

class TextStoryItem extends StatelessWidget {
  final Story story;
  final bool editable;
  final VoidCallback onTap;
  const TextStoryItem(this.story, {Key key, this.editable = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (this.onTap != null) {
            this.onTap();
          }
        },
        child: editable
            ? ListTile(
                title: new Text(
                story.data,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(decoration: TextDecoration.underline),
              ))
            : ListTile(
                title: new Text(
                story.data,
                style: Theme.of(context).textTheme.bodyText2,
              )));
  }
}
