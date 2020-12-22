import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/logic/bloc/memories_bloc.dart';
import 'package:memorme_android_flutter/pages/edit_memory_page.dart';
import 'package:memorme_android_flutter/widgets/memories_grid.dart';
import 'package:memorme_android_flutter/widgets/memories_list.dart';

class DisplayMemoriesPage extends StatefulWidget {
  final bool listView;
  final int focusedIndex;

  DisplayMemoriesPage({Key key, this.listView = false, this.focusedIndex = 0})
      : super(key: key);

  @override
  _DisplayMemoriesPageState createState() => _DisplayMemoriesPageState();
}

class _DisplayMemoriesPageState extends State<DisplayMemoriesPage> {
  MemoriesBloc memoriesBloc;

  @override
  void initState() {
    super.initState();
    // load the memories
    memoriesBloc = BlocProvider.of<MemoriesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Memories"),
        ),
        floatingActionButton: FloatingActionButton(
          key: Key("AddMemoryFAB"),
          onPressed: () {
            //display memory UI
            Navigator.pushNamed(context, '/edit_memory', 
              arguments: EditMemoryArguments(
                (memory){
                  memoriesBloc.add(MemoriesMemoryAdded(memory));
                }
              )
            );
          },
          child: Icon(Icons.add),
        ),
        body: BlocConsumer<MemoriesBloc, MemoriesState>(
          cubit: memoriesBloc,
          builder: (context, state) {
            //rebuild on state change
            if (state is MemoriesLoadSuccess) {
              //load successful
              //check to see if we're rendering a listview or a gridview
              return widget.listView
                  ? MemoriesList(
                      memories: state.memories,
                      focusedIndex: widget.focusedIndex,
                    )
                  : MemoriesGrid(
                      memories: state.memories,
                      onTileTap: (memory, index) {
                        //navigate to listview display
                        //not sure if we should be doing this or just create a separate thing for it
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext buildContext) =>
                                  BlocProvider.value(
                                      value: memoriesBloc,
                                      child: DisplayMemoriesPage(
                                        listView: true,
                                        focusedIndex: index,
                                      ))),
                        );
                      },
                    );
            } else {
              //it's loading or it failed
              //TODO: make an actual loading symbol
              return Container(
                child: Text("LOADING"),
              );
            }
          },
          listener: (BuildContext context, MemoriesState state) {
            if (state is MemoriesSaveSuccess) {
              //if saved correctly, load the memories
              memoriesBloc.add(MemoriesLoaded());
            }
            //TODO: else give error
          },
        ));
  }
}
