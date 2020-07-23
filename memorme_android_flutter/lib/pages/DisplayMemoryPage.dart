import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/pages/TakePicturePage.dart';
import 'package:memorme_android_flutter/widgets/FullscreenTextField.dart';
import 'package:memorme_android_flutter/widgets/StoryItem.dart';

class DisplayMemoryPage extends StatefulWidget {
  final String memoryPath;
  DisplayMemoryPage({Key key, this.memoryPath}) : super(key: key);

  @override
  _DisplayMemoryPageState createState() => _DisplayMemoryPageState();
}

class _DisplayMemoryPageState extends State<DisplayMemoryPage> {
  List<String> _images = [];
  List<String> _stories = [];
  int currentImage = 1;

  @override
  void initState() {
    super.initState();
  }

  // a builder for the list of stories
  Widget _buildStoriesList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of story items we have. So, we need to check the index is OK.
        if (index < _stories.length) {
          return _buildStoryItem(index);
        }
      },
    );
  }

  // a builder for a single story
  Widget _buildStoryItem(int storyIndex) {
    return StoryItem(
      _stories[storyIndex],
      editable: true,
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return FullscreenTextField(
            text: _stories[storyIndex],
            onSave: (val) {
              if (_stories[storyIndex] != val) {
                setState(() {
                  _stories[storyIndex] = val;
                });
              }
            },
          );
        }));
      },
    );
  }

  // call to add a story to the list
  void _addStory(String story) {
    // Only add the story if the user actually entered something
    if (story.length > 0) {
      setState(() => _stories.add(story));
    }
  }

  Widget _createCarousel() {
    return GestureDetector(
      //only perform gesture when there aren't any images
      onTap: _images.length < 1
          ? () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TakePictureScreen(
                  takePictureCallback: (path) => {
                    this.setState(() {
                      _images.add(path);
                      Navigator.pop(context);
                    })
                  },
                ),
              ))
          : () => {},
      child: Container(
        //set height to be width (make a square)
        height: MediaQuery.of(context).size.width,
        child: Center(
            //TODO set constraints on the size of the image
            //if there are images, build a carousel
            child: (_images.length > 0)
                ? (_images.length > 1)
                    ? CarouselSlider.builder(
                        itemCount: _images.length,
                        options: CarouselOptions(
                          aspectRatio: 1.0,
                          enlargeCenterPage: true,
                          autoPlay: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentImage = index + 1;
                            });
                          },
                        ),
                        itemBuilder: (ctx, index) {
                          return Container(
                              child: Image.file(
                            File(_images[index]),
                            fit: BoxFit.contain,
                          ));
                        },
                      )
                    : Column(
                        children: <Widget>[
                          Expanded(
                            child: Image.file(
                              File(_images[0]),
                              fit: BoxFit.contain,
                            ),
                          )
                        ],
                      )

                //otherwise, build an "add picture" button
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_circle,
                        size: 150,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        "Add a photo!",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  )),
      ),
    );
  }

  Widget _createToolBar() {
    return _images.length > 0
        ? Row(
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
                  currentImage.toString() + "/" + _images.length.toString(),
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              )),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakePictureScreen(
                            takePictureCallback: (path) => {
                              this.setState(() {
                                _images.add(path);
                                Navigator.pop(context);
                              })
                            },
                          ),
                        )),
                    child: Icon(
                      Icons.add_photo_alternate,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  )),
            ],
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Memory')),
      body: Container(
        child: Column(
          children: <Widget>[
            //add the top part, which holds the carousel
            _createCarousel(),
            //only display toolbar row if there aren't any images
            _createToolBar(),
            //display stories list
            Expanded(
              child: _buildStoriesList(),
            ),
          ],
        ),
      ),
      //only show FAB if there are images
      floatingActionButton: (_images.length > 0)
          ? new FloatingActionButton(
              onPressed:
                  _pushAddStoryScreen, // pressing the + button opens the new story screen
              tooltip: 'Add Memory',
              child: new Icon(Icons.add))
          : null,
    );
  }

  void _pushAddStoryScreen({String text}) {
    // Push this page onto the stack
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return FullscreenTextField(
        text: text,
        onSave: (val) {
          _addStory(val);
        },
      );
    }));
  }
}
