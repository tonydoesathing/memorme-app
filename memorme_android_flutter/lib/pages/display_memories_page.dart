import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/logic/bloc/memories_bloc.dart';
import 'package:memorme_android_flutter/pages/edit_memory_page.dart';
import 'package:memorme_android_flutter/widgets/loading_indicator.dart';
import 'package:memorme_android_flutter/widgets/memories_grid.dart';
//import 'package:memorme_android_flutter/widgets/memories_list2.dart';
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
                arguments: EditMemoryArguments((memory) {
              memoriesBloc.add(MemoriesMemoryAdded(memory));
            }));
          },
          child: Icon(Icons.add),
        ),
        body: BlocConsumer<MemoriesBloc, MemoriesState>(
          cubit: memoriesBloc,
          builder: (context, state) {
            //rebuild on state change
            if (state is MemoriesLoadSuccess) {
              //load successful

              //sort memories by date created before passing to list or grid widget
              List<Memory> sortedMemories = state.memories;
              sortedMemories.sort((a,b)=>b.dateCreated.compareTo(a.dateCreated));

              //check to see if we're rendering a listview or a gridview
              return widget.listView
                  ? MemoriesList(
                      memories: sortedMemories,
                      focusedIndex: widget.focusedIndex,
                    )
                  : MemoriesGrid(
                      memories: sortedMemories,
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
              return Center(
                child: LoadingIndicator(
                  width: 100,
                  height: 100,
                ),
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
