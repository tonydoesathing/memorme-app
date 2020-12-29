import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/pages/take_picture_page.dart';
import 'package:memorme_android_flutter/widgets/fullscreen_text_field.dart';
import 'package:memorme_android_flutter/widgets/story_items/text_story_item.dart';

class EditMemoryArguments {
  final Function onSave;

  EditMemoryArguments(this.onSave);
}

class EditMemoryPage extends StatefulWidget {
  final void Function(Memory value) onSave;
  final Memory memory;
  EditMemoryPage({Key key, this.onSave, this.memory}) : super(key: key);

  @override
  _EditMemoryPageState createState() => _EditMemoryPageState();
}

class _EditMemoryPageState extends State<EditMemoryPage> {
  List<Story> _media = [];
  List<Story> _stories = [];
  int _currentImage = 1;

  @override
  void initState() {
    super.initState();
    if (widget.memory != null) {
      //if it's an old memory, populate _media and _stories lists
      for (Story story in widget.memory.stories) {
        if (story.type == StoryType.PICTURE_STORY) {
          // if the story's a picture story, add it to _media
          _media.add(story);
        } else if (story.type == StoryType.TEXT_STORY) {
          //if it's a text story, add it to _stories
          _stories.add(story);
        }
      }
    }
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
        TextStoryItem(
          _stories[storyIndex],
          editable: true,
          onTap: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return FullscreenTextField(
                text: _stories[storyIndex].data,
                onSave: (val) {
                  if (_stories[storyIndex].data != val) {
                    //update the story if different
                    setState(() {
                      _stories[storyIndex] = Story.editStory(
                          _stories[storyIndex],
                          val,
                          DateTime.now().millisecondsSinceEpoch);
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
      setState(() => _stories.add(Story(
          null,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch,
          story,
          StoryType.TEXT_STORY)));
    }
  }

  ///creates a button to take a photo if there are not photos
  Widget _createTakePhotoButton() {
    return GestureDetector(
      //send to TakePictureScreen on tap
      onTap: () {
        Navigator.pushNamed(context, '/take_picture',
            arguments: TakePictureArguments((path) => {
                  this.setState(() {
                    _media.add(Story(
                        null,
                        DateTime.now().millisecondsSinceEpoch,
                        DateTime.now().millisecondsSinceEpoch,
                        path,
                        StoryType.PICTURE_STORY));
                    Navigator.pop(context);
                  })
                }));
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
                        File(_media[index].data),
                        fit: BoxFit.contain,
                      ));
                    },
                  )
                //if there's just one image, just show the image
                : Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.file(
                          File(_media[0].data),
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
                    onTap: () => {
                      Navigator.pushNamed(context, '/take_picture',
                          arguments: TakePictureArguments((path) => {
                                this.setState(() {
                                  _media.add(Story(
                                      null,
                                      DateTime.now().millisecondsSinceEpoch,
                                      DateTime.now().millisecondsSinceEpoch,
                                      path,
                                      StoryType.PICTURE_STORY));
                                  Navigator.pop(context);
                                })
                              }))
                    },
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
        // if we're editing a memory
        if (widget.memory != null) {
          widget.onSave(Memory(
              widget.memory.id,
              widget.memory.dateCreated,
              DateTime.now().millisecondsSinceEpoch,
              widget.memory.storyPreviewId,
              [..._media, ..._stories]));
        } else {
          // if it's a new memory
          // TODO: figure out how to give it a story preview id
          widget.onSave(Memory(
              null,
              DateTime.now().millisecondsSinceEpoch,
              DateTime.now().millisecondsSinceEpoch,
              1,
              [..._media, ..._stories]));
        }
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
