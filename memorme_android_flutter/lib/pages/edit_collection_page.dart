import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/logic/edit_collection_bloc/edit_collection_bloc.dart';
import 'package:memorme_android_flutter/widgets/memory/memory_preview.dart';

import 'edit_memory_page.dart';

class EditCollectionArguments {
  final Function(Collection value) onSave;
  final Collection collection;

  EditCollectionArguments({this.onSave, this.collection});
}

class EditCollectionPage extends StatefulWidget {
  final Function(Collection value) onSave;
  EditCollectionPage({Key key, this.onSave}) : super(key: key);

  @override
  _EditCollectionPageState createState() => _EditCollectionPageState();
}

class _EditCollectionPageState extends State<EditCollectionPage> {
  EditCollectionBloc _editCollectionBloc;

  @override
  void initState() {
    super.initState();
    _editCollectionBloc = BlocProvider.of<EditCollectionBloc>(context);
  }

  /// let user know [Collection] needs at least one memory
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('A collection must have at least one memory!'),
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

  void _checkCanSave(EditCollectionBlocState state) {
    // check to make sure there's everything for a Collection
    if (state.mcRelations.length > 0) {
      _editCollectionBloc.add(EditCollectionBlocSaveCollection());
    } else {
      _showDialog();
    }
  }

  Future<bool> _onPop(EditCollectionBlocState state) {
    // unfocus the textbox
    FocusManager.instance.primaryFocus.unfocus();

    // if we've modified the collection and user backs out
    // check to see if user wants to discard it
    if (state.collection != state.initialCollection) {
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
                  // do something with the discard
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
    return BlocConsumer<EditCollectionBloc, EditCollectionBlocState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.initialCollection.id != null
                ? "Edit Collection"
                : "New Collection"),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  // close
                  _onPop(state).then((value) {
                    if (value) Navigator.pop(context);
                  });
                }),
            actions: <Widget>[
              if (state.changed)
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      _checkCanSave(state);
                    })
            ],
          ),
          body: Builder(builder: (context) {
            if (state is EditCollectionLoading) {
              return Text("Loading");
            } else {
              return WillPopScope(
                onWillPop: () async => await _onPop(state),
                child: GestureDetector(
                    onTap: () {
                      // unfocus the textbox
                      FocusManager.instance.primaryFocus.unfocus();
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.mcRelations != null
                                ? state.mcRelations.length + 1
                                : 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // title

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 16.0,
                                      left: 8.0,
                                      right: 8.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0,
                                          bottom: 16.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: TextFormField(
                                        onEditingComplete: () {
                                          FocusManager.instance.primaryFocus
                                              .unfocus();
                                        },
                                        onChanged: (value) {
                                          _editCollectionBloc.add(
                                              EditCollectionBlocEditTitle(
                                                  value));
                                        },
                                        initialValue:
                                            state.collection.title ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                        keyboardType: TextInputType.text,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                            hintText: "Title (Optional)",
                                            // border: InputBorder.none,
                                            // focusedBorder: InputBorder.none,
                                            // enabledBorder: InputBorder.none,
                                            // errorBorder: InputBorder.none,
                                            // disabledBorder: InputBorder.none,
                                            contentPadding: EdgeInsets.zero),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                // load mcRelations
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, left: 8.0, right: 8.0),
                                  child: Center(
                                    child: MemoryPreview(
                                        width: 200,
                                        memory: state.memories[state
                                            .mcRelations[index - 1].memoryID]),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                          colors: [
                                        Theme.of(context).primaryColor,
                                        Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.4)
                                      ])),
                                  child: SizedBox(
                                    height: 72.0,
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.all(8.0),
                                      children: [
                                        // Padding(
                                        //   padding: const EdgeInsets.all(8.0),
                                        //   child: RaisedButton.icon(
                                        //     onPressed: () {},
                                        //     icon: Icon(Icons.add_to_photos),
                                        //     label: Text("Add Existing Memory"),
                                        //     color: Colors.white,
                                        //     shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10)),
                                        //     textColor: Theme.of(context)
                                        //         .textTheme
                                        //         .button
                                        //         .color,
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton.icon(
                                            onPressed: () {
                                              FocusManager.instance.primaryFocus
                                                  .unfocus();
                                              Navigator.pushNamed(
                                                  context, '/edit_memory',
                                                  arguments:
                                                      EditMemoryArguments(
                                                          onSave: (memory) {
                                                _editCollectionBloc.add(
                                                    EditCollectionBlocAddMemory(
                                                        memory));
                                              }));
                                            },
                                            icon: Icon(Icons.add_circle),
                                            label: Text("Add New Memory"),
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            textColor: Theme.of(context)
                                                .textTheme
                                                .button
                                                .color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        )
                      ],
                    )),
              );
            }
          }),
        );
      },
      listener: (context, state) {
        if (state is EditCollectionSaved) {
          // saved properly
          if (widget.onSave != null) {
            widget.onSave(state.collection);
          }
          Navigator.pop(context);
        } else if (state is EditCollectionError) {
          print("ERROR! ${state.errorCode}");
        }
      },
    );
  }
}
