import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/logic/view_collection_bloc/view_collection_bloc.dart';
import 'package:memorme_android_flutter/pages/view_memory_page.dart';
import 'package:memorme_android_flutter/widgets/memories_grid.dart';

import 'edit_collection_page.dart';

class ViewCollectionArguments {
  final Collection collection;

  ViewCollectionArguments({this.collection});
}

class ViewCollectionPage extends StatelessWidget {
  const ViewCollectionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewCollectionBloc, ViewCollectionBlocState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.collection?.title ?? ""),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(context, '/edit_collection',
                      arguments: EditCollectionArguments(
                        collection: state.collection,
                        onSave: (collection) {
                          // BlocProvider.of<ViewCollectionBloc>(context)
                          //     .add(ViewCollectionBlocLoadMemories(true));
                        },
                      ));
                },
              )
            ],
          ),
          body: MemoriesGrid(
            memories: state.memories,
            onTileTap: (memory, index) {
              Navigator.pushNamed(context, '/view_memory',
                  arguments: ViewMemoryPageArguments(memory));
            },
            shouldCheckScroll: () {
              return true;
            },
            onScrollHit: () {
              BlocProvider.of<ViewCollectionBloc>(context)
                  .add(ViewCollectionBlocLoadMemories(false));
            },
          ),
        );
      },
      listener: (context, state) {
        if (state is ViewCollectionBlocError) {
          print(state.errorCode);
        }
      },
    );
  }
}
