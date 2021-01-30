
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
      child: Card(
        margin: EdgeInsetsDirectional.fromSTEB(15, 8, 15, 8), 
        child: Container(
          color: Colors.lightBlue[50],
          padding: EdgeInsetsDirectional.only(start: 10, end: 10),
          child: Text(
            textStory.data, 
            style: TextStyle(color: Colors.black, fontSize: 12),
            overflow: TextOverflow.fade)
        )
      )
    );
  }
}
