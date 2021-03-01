
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';

class PictureStoryItem extends StatelessWidget {
  final Story story;
  final bool editable;
  final VoidCallback onTap;
  const PictureStoryItem(this.story, {Key key, this.editable = false, this.onTap})
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
        //TODO: [MMA-92] make picture stories editable
        ? Image.file(
            File(story.data),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(story.data),
            fit: BoxFit.contain,
          )
      );
  }
}
