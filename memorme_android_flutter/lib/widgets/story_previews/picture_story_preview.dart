
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';

/// Makes a preview for a given [pictureStory]
class PictureStoryPreview extends StatelessWidget{

  final Story pictureStory;

  const PictureStoryPreview(this.pictureStory, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
        color: Colors.blue,
        child: Image.file(File(pictureStory.data),fit: BoxFit.cover)
      );
  }
}
