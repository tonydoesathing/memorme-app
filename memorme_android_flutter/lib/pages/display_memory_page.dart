import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memory.dart';
import 'package:memorme_android_flutter/pages/take_picture_page.dart';
import 'package:memorme_android_flutter/widgets/fullscreen_text_field.dart';
import 'package:memorme_android_flutter/widgets/story_item.dart';

class DisplayMemoryPage extends StatefulWidget {
  final void Function(Memory value) onSave;
  DisplayMemoryPage({Key key, this.onSave}) : super(key: key);

  @override
  _DisplayMemoryPageState createState() => _DisplayMemoryPageState();
}

class _DisplayMemoryPageState extends State<DisplayMemoryPage> {
  List<String> _media;
  List<String> _stories;
  int _currentImage = 1;

  @override
  void initState() {
    super.initState();
    _media = [];
    _stories = [];
  }

  /// builds a list of story items
  Widget _buildStoriesList() {
    return new ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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

  /// builds a single story display using a [storyIndex] of [_memory]'s stories
  Widget _buildStoryItem(int storyIndex) {
    return Column(
      children: <Widget>[
        // show a Divider when it's not the first story
        if (storyIndex > 0)
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Divider(
              thickness: 1,
            ),
          ),
        StoryItem(
          _stories[storyIndex],
          editable: true,
          onTap: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
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
        ),
      ],
    );
  }

  /// adds a [story] to [_memory]'s stories
  void _addStory(String story) {
    // Only add the story if the user actually entered something
    if (story.length > 0) {
      setState(() => _stories.add(story));
    }
  }

  ///creates a button to take a photo if there are not photos
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
                    _media.add(path);
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

  /// creates the carousel to display media
  Widget _createCarousel() {
    //if there aren't any images, offer a "Take Photo" button
    if (_media.length < 1) {
      return _createTakePhotoButton();
    } else {
      //otherwise, display the image
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
                      return Container(
                          child: Image.file(
                        File(_media[index]),
                        fit: BoxFit.contain,
                      ));
                    },
                  )
                //if there's just one image, just show the image
                : Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.file(
                          File(_media[0]),
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  )),
      );
    }
  }

  /// creates the toolbar below the carousel
  Widget _createToolBar() {
    //check to see if there are images
    return _media.length > 0
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
                  _currentImage.toString() + "/" + _media.length.toString(),
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
                                _media.add(path);
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

  /// shows a dialog explaining to the user that they need a story and a photo
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('A memory must have at least one story and photo!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// checks to see if [_memory] is fit to save,
  /// specifically by checking to see if it has
  /// a story and a media
  void _checkCanSave() {
    if (this._media.length < 1 || this._stories.length < 1) {
      _showDialog();
    } else {
      if (widget.onSave != null) {
        widget.onSave(Memory(_media, _stories));
      }
      Navigator.pop(context);
    }
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
              _checkCanSave();
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
      floatingActionButton: (_media.length > 0)
          ? new FloatingActionButton(
              onPressed:
                  _pushAddStoryScreen, // pressing the + button opens the new story screen
              tooltip: 'Add Memory',
              child: new Icon(Icons.add))
          : null,
    );
  }

  /// navigates to the [FullscreenTextField] page, filling in the
  /// textbox with an optional [text] string
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
