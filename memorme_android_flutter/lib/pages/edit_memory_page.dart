import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/logic/edit_memory_bloc/edit_memory_bloc.dart';
import 'package:memorme_android_flutter/logic/memories_bloc/memories_bloc.dart';
import 'package:memorme_android_flutter/pages/take_picture_page.dart';
import 'package:memorme_android_flutter/widgets/fullscreen_text_field.dart';
import 'package:memorme_android_flutter/widgets/story_items/picture_story_item.dart';
import 'package:memorme_android_flutter/widgets/story_items/text_story_item.dart';

class EditMemoryArguments {
  final Function onSave;
  final Memory memory;

  EditMemoryArguments({this.onSave, this.memory});
}

class EditMemoryPage extends StatefulWidget {
  final void Function(Memory value) onSave;

  EditMemoryPage({Key key, this.onSave}) : super(key: key);

  @override
  _EditMemoryPageState createState() => _EditMemoryPageState();
}

class _EditMemoryPageState extends State<EditMemoryPage> {
  EditMemoryBloc _editMemoryBloc;

  @override
  void initState() {
    super.initState();
    _editMemoryBloc = BlocProvider.of<EditMemoryBloc>(context);
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
  void _checkCanSave(Memory memory) {
    if (memory.stories.length == 0) {
      _showDialog();
    } else {
      _editMemoryBloc.add(EditMemoryBlocSaveMemory());
    }
  }

  Future<bool> _onPop(EditMemoryState state) {
    // if we've modified the memory and user backs out
    // check to see if user wants to discard it
    if (state.memory != state.initialMemory) {
      return showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Discard your changes?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  // discard the memory
                  _editMemoryBloc.add(EditMemoryBlocDiscardMemory());
                  // close the dialog and allow it to pop
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        },
      ).then((value) => value ?? false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditMemoryBloc, EditMemoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Make Memory'),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  // close
                  _onPop(state).then((value) {
                    if (value) Navigator.pop(context);
                  });
                }),
            actions: <Widget>[
              // only display if it's been edited in some form
              if (state.memory != state.initialMemory)
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    // save
                    _checkCanSave(state.memory);
                  },
                ),
            ],
          ),
          // check to see if user is going back and trying to discard
          body: !(state is EditMemoryDiscarded)
              ? WillPopScope(
                  onWillPop: () async => await _onPop(state),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        // build list of stories
                        child: ListView.builder(
                          itemCount: state.memory.stories.length,
                          itemBuilder: (context, index) {
                            Story s = state.memory.stories[index];
                            Widget w = Text("No preview for $s");
                            if (s.type == StoryType.TEXT_STORY) {
                              w = TextStoryItem(s);
                            } else if (s.type == StoryType.PICTURE_STORY) {
                              w = PictureStoryItem(s);
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: w,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // add photo button
                            RaisedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/take_picture',
                                    arguments: TakePictureArguments((path) {
                                  _editMemoryBloc.add(EditMemoryBlocAddStory(
                                      Story(
                                          dateCreated: DateTime.now()
                                              .millisecondsSinceEpoch,
                                          dateLastEdited: DateTime.now()
                                              .millisecondsSinceEpoch,
                                          data: path,
                                          type: StoryType.PICTURE_STORY)));
                                  Navigator.pop(context);
                                }));
                              },
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.add_a_photo),
                                  Text("Add Photo")
                                ],
                              ),
                            ),
                            // add text button
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(builder: (context) {
                                  return FullscreenTextField(
                                    text: "",
                                    onSave: (val) {
                                      _editMemoryBloc.add(
                                          EditMemoryBlocAddStory(Story(
                                              dateCreated: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              dateLastEdited: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              data: val,
                                              type: StoryType.TEXT_STORY)));
                                    },
                                  );
                                }));
                              },
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.add_comment),
                                  Text("Add Text")
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
        );
      },
      listener: (context, state) {
        // we check to see if we've gotten the EditMemorySaved state
        if (state is EditMemorySaved) {
          // this means save was successful
          if (widget.onSave != null) {
            widget.onSave(state.memory);
          }
          Navigator.pop(context);
        } else if (state is EditMemoryError) {
          print(state.errorCode);
        }
      },
    );
  }
}
