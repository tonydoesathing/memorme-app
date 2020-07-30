import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/models/memory.dart';
import 'package:memorme_android_flutter/pages/TakePicturePage.dart';
import 'package:memorme_android_flutter/widgets/FullscreenTextField.dart';
import 'package:memorme_android_flutter/widgets/StoryItem.dart';

class DisplayMemoryPage extends StatefulWidget {
  final String memoryPath;
  final void Function(Memory value) onSave;
  DisplayMemoryPage({Key key, this.memoryPath, this.onSave}) : super(key: key);

  @override
  _DisplayMemoryPageState createState() => _DisplayMemoryPageState();
}

class _DisplayMemoryPageState extends State<DisplayMemoryPage> {
  Memory _memory;
  int currentImage = 1;

  @override
  void initState() {
    super.initState();
    _memory = Memory();
  }

  // a builder for the list of stories
  Widget _buildStoriesList() {
    return new ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of story items we have. So, we need to check the index is OK.
        if (index < _memory.getAllStories().length) {
          return _buildStoryItem(index);
        }
      },
    );
  }

  // a builder for a single story
  Widget _buildStoryItem(int storyIndex) {
    return StoryItem(
      _memory.getStory(storyIndex),
      editable: true,
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return FullscreenTextField(
            text: _memory.getStory(storyIndex),
            onSave: (val) {
              if (_memory.getStory(storyIndex) != val) {
                setState(() {
                  _memory.editStory(storyIndex, val);
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
      setState(() => _memory.addStory(story));
    }
  }

  Widget _createTakePhotoButton() {
    return GestureDetector(
      //send to TakePictureScreen on tap
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                takePictureCallback: (path) => {
                  this.setState(() {
                    _memory.addMedia(path);
                    Navigator.pop(context);
                  })
                },
              ),
            ));
      },
      //create a button with some text centered in the carousel space
      child: Container(
        height: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_circle,
              size: 150,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              "Take a photo!",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createCarousel() {
    //if there aren't any images, offer a "Take Photo" button
    if (_memory.getAllMedia().length < 1) {
      return _createTakePhotoButton();
    } else {
      //otherwise, display the image
      return Container(
        //set height to be width (make a square)
        height: MediaQuery.of(context).size.width,
        child: Center(
            //if there are images, build a carousel
            child: (_memory.getAllMedia().length > 1)
                ? CarouselSlider.builder(
                    itemCount: _memory.getAllMedia().length,
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
                        File(_memory.getMedia(index)),
                        fit: BoxFit.contain,
                      ));
                    },
                  )
                //if there's just one image, just show the image
                : Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.file(
                          File(_memory.getMedia(0)),
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  )),
      );
    }
  }

  Widget _createToolBar() {
    //check to see if there are images
    return _memory.getAllMedia().length > 0
        //if there are, create a toolbar with a button on the right
        //and a centered image display (so you can see what image you're on)
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
                  currentImage.toString() +
                      "/" +
                      _memory.getAllMedia().length.toString(),
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
                                _memory.addMedia(path);
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
        //if there aren't, return an empty, formless container
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Memory'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (widget.onSave != null) {
                widget.onSave(_memory);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
      //create a scrollable listview
      body: ListView(
        children: <Widget>[
          //add the top part, which holds the carousel
          _createCarousel(),
          //only display toolbar row if there aren't any images
          _createToolBar(),
          //display stories list
          _buildStoriesList(),
        ],
      ),
      //only show FAB if there are images
      floatingActionButton: (_memory.getAllMedia().length > 0)
          ? new FloatingActionButton(
              onPressed:
                  _pushAddStoryScreen, // pressing the + button opens the new story screen
              tooltip: 'Add Memory',
              child: new Icon(Icons.add))
          : null,
    );
  }

  void _pushAddStoryScreen({String text}) {
    // navigate to the fullscreen text field page
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
