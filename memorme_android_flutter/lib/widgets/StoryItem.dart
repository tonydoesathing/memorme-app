import 'package:flutter/material.dart';


class StoryItem extends StatelessWidget {
  final String story;
  final bool editable;
  final VoidCallback onTap;
  const StoryItem(this.story, {Key key, this.editable = false, this.onTap})
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
                story,
                style: TextStyle(decoration: TextDecoration.underline),
              ))
            : ListTile(title: new Text(story)));
  }
}
