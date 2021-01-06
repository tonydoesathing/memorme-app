
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/pages/take_picture_page.dart';
import 'package:memorme_android_flutter/widgets/fullscreen_text_field.dart';
import 'package:memorme_android_flutter/widgets/story_items/picture_story_item.dart';
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

class _EditMemoryPageState extends State<EditMemoryPage>{

  List<Story> stories = [];

  @override
  void initState() {
    super.initState();
    if (widget.memory != null) stories = widget.memory.stories;
  }
  
  /// let user know memory needs at least one story
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('A memory must have at least one story!'),
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
  /// at least one story
  void _checkCanSave() {
    if (stories.length == 0){
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
              stories));
        } else {
          // if it's a new memory
          // TODO: figure out how to give it a story preview id
          widget.onSave(Memory(
              null,
              DateTime.now().millisecondsSinceEpoch,
              DateTime.now().millisecondsSinceEpoch,
              1,
              stories));
        }
      }
      Navigator.pop(context);
    }
  }

  /// creates a button that pushes add story screen
  Widget _createAddStoryButton() {
    return GestureDetector(
      //send to TakePictureScreen on tap
      onTap: () {
        _pushAddStoryScreen();
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
              "Add a story!",
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

  /// navigates to the [FullscreenTextField] page, filling in the
  /// textbox with an optional [text] string
  void _pushAddText({String text}) {
    Navigator.pop(context);
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

  /// adds a [story] to [_memory]'s stories
  void _addStory(String story) {
    // Only add the story if the user actually entered something
    if (story.length > 0) {
      setState(() => stories.add(Story(
          null,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch,
          story,
          StoryType.TEXT_STORY)));
    }
  }

  /// pushes take picture page, adding picture to stories
  void _pushAddPicture(){
    Navigator.pop(context);
    Navigator.pushNamed(context, '/take_picture',
      arguments: TakePictureArguments((path) => {
        this.setState(() {
          stories.add(Story(
            null,
            DateTime.now().millisecondsSinceEpoch,
            DateTime.now().millisecondsSinceEpoch,
            path,
            StoryType.PICTURE_STORY)
          );
          Navigator.pop(context);
        })
      })
    );
  }

  /// pushes add story screen, which gives options of adding a picture or text
  void _pushAddStoryScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add a Story'),
        ),
        body: ListView(
          children: [
            // add picture option
            GestureDetector(
              onTap: _pushAddPicture,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Take a picture',
                    style: TextStyle(
                      fontSize:30,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    )
                  )
                ),
              )
            ),
            // add text option
            GestureDetector(
              onTap: _pushAddText,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Add some text',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor
                    )
                  )
                ),
              )
            )
          ],
        )
      );
    }));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Memory'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _checkCanSave();
            },
          ),
        ],
      ),
      //prompt user to make first story, if stories already exist then show simple FAB
      body: stories.length == 0 ? 
        Center(
          child: _createAddStoryButton()
        ) :
        ListView(
          children: [
            Column(
              children: <Widget>[
                for (Story s in stories) s.type == StoryType.TEXT_STORY ? Padding(padding: EdgeInsets.all(10), child: TextStoryItem(s)) : Padding(padding: EdgeInsets.all(10), child: PictureStoryItem(s))
              ],
            ),
          ]
        )
      ,
      floatingActionButton: stories.length != 0 ? 
        FloatingActionButton(
          onPressed:
            _pushAddStoryScreen, // pressing the + button opens the new story screen
          tooltip: 'Add Memory',
          child: new Icon(Icons.add)
        ) :
        null
    );
  }
}
