import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/models/memory.dart';
import 'package:memorme_android_flutter/widgets/story_item.dart';

class MemoryDisplay extends StatefulWidget {
  final Memory memory;
  const MemoryDisplay(this.memory, {Key key}) : super(key: key);

  @override
  _MemoryDisplayState createState() => _MemoryDisplayState();
}

class _MemoryDisplayState extends State<MemoryDisplay> {
  int _currentImage = 1;

  Widget _carousel(BuildContext context) {
    return Container(
      //set height to be width (make a square)
      height: MediaQuery.of(context).size.width,
      child: Center(
          //if there are images, build a carousel
          child: (widget.memory.getAllMedia().length > 1)
              ? CarouselSlider.builder(
                  itemCount: widget.memory.getAllMedia().length,
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
                    return Container(
                        child: Image.file(
                      File(widget.memory.getMedia(index)),
                      fit: BoxFit.contain,
                    ));
                  },
                )
              //if there's just one image, just show the image
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: Image.file(
                        File(widget.memory.getMedia(0)),
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                )),
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
            _currentImage.toString() +
                "/" +
                widget.memory.getAllMedia().length.toString(),
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        )),
        Padding(
            padding: EdgeInsets.all(8),
            child: GestureDetector(
              key: Key("EditMemoryButton"),
              onTap: () => print("Edit"),
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
      children: <Widget>[
        for (String s in widget.memory.getAllStories()) StoryItem(s)
      ],
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
