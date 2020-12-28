import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/pages/edit_memory_page.dart';
import 'package:memorme_android_flutter/widgets/story_items/text_story_item.dart';

class MemoryDisplay extends StatefulWidget {
  final Memory memory;
  const MemoryDisplay(this.memory, {Key key}) : super(key: key);

  @override
  _MemoryDisplayState createState() => _MemoryDisplayState();
}

class _MemoryDisplayState extends State<MemoryDisplay> {
  int _currentImage = 1;
  final List<Story> _media = [];
  final List<Story> _textStories = [];

  @override
  void initState() {
    super.initState();
    //go through all the stories
    for (Story story in widget.memory.stories) {
      if (story.type == StoryType.PICTURE_STORY) {
        //add pictures to the [_media] list
        _media.add(story);
      } else if (story.type == StoryType.TEXT_STORY) {
        // add text to the [_textStories] list
        _textStories.add(story);
      }
    }
  }

  Widget _carousel(BuildContext context) {
    return Container(
      //set height to be width (make a square)
      height: MediaQuery.of(context).size.width,
      child: Center(
          //if there are images, build a carousel
          child: (_media.length > 1)
              ? CarouselSlider.builder(
                  itemCount: _media.length,
                  options: CarouselOptions(
                    aspectRatio: 1.0,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentImage = index + 1;
                      });
                    },
                  ),
                  itemBuilder: (ctx, index) {
                    /*child: Image.file(
                      File(widget.memory.getMedia(index)),
                      fit: BoxFit.contain,
                    ) */
                    /*
                      child: Image.asset(
                        "assets/graphics/InvalidImage.png",
                        fit: BoxFit.contain,
                      ),
                    */
                    return Container(
                      child: Image.file(
                        File(_media[index].data),
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                )
              //if there's just one image, just show the image
              : (_media.length == 1)
                  ? Column(
                      children: <Widget>[
                        /*child: Image.file(
                        File(widget.memory.getMedia(0)),
                        fit: BoxFit.contain,
                      ), */
                        /*
                      Image.asset(
                        "assets/graphics/InvalidImage.png",
                        fit: BoxFit.contain,
                      ),
                      */
                        Expanded(
                          child: Image.file(
                            File(_media[0].data),
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    )
                  // if there isn't, don't show anything
                  : Container()),
    );
  }

  Widget _toolbar() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            width: 30,
            height: 30,
          ),
        ),
        Expanded(
            child: Align(
          alignment: Alignment.center,
          child: Text(
            _currentImage.toString() + "/" + _media.length.toString(),
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        )),
        Padding(
            padding: EdgeInsets.all(8),
            child: GestureDetector(
              key: Key("EditMemoryButton"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => EditMemoryPage(
                              memory: widget.memory,
                            )));
              },
              child: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            )),
      ],
    );
  }

  Widget _stories() {
    return Column(
      children: <Widget>[for (Story s in _textStories) TextStoryItem(s)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_carousel(context), _toolbar(), _stories()],
      ),
    );
  }
}
