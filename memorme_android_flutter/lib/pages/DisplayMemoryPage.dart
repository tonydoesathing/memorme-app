import 'dart:io';

import 'package:flutter/material.dart';

class DisplayMemoryPage extends StatefulWidget {
  final String imagePath;
  DisplayMemoryPage({Key key, this.imagePath}) : super(key: key);

  @override
  _DisplayMemoryPageState createState() => _DisplayMemoryPageState();
}

class _DisplayMemoryPageState extends State<DisplayMemoryPage> {
  List<String> _stories = [];

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
    return new ListTile(title: new Text(_stories[storyIndex]));
  }

  // call to add a story to the list
  void _addStory(String story) {
    // Only add the story if the user actually entered something
    if (story.length > 0) {
      setState(() => _stories.add(story));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Memory')),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black,
              child: Center(
                //TODO set constraints on the size of the image
                child: Image.file(File(widget.imagePath)),
              ),
            ),
            Expanded(
              child: _buildStoriesList(),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed:
              _pushAddStoryScreen, // pressing the + button opens the new story screen
          tooltip: 'Add Memory',
          child: new Icon(Icons.add)),
    );
  }

  void _pushAddStoryScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('Add a new story')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addStory(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: new InputDecoration(
                hintText: 'Enter a story about the memory...',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
