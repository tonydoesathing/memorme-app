
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';

/// Makes a preview for a given [textStory]
class TextStoryPreview extends StatelessWidget{

  final Story textStory;

  const TextStoryPreview(this.textStory, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
        child: Text(textStory.data, style: TextStyle(color: Colors.blue, fontSize: 20))
      );
  }
}
