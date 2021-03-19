import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/logic/collections_bloc/collections_bloc.dart';
import 'package:memorme_android_flutter/pages/edit_collection_page.dart';
import 'package:memorme_android_flutter/widgets/BottomNavBar.dart';
import 'package:memorme_android_flutter/widgets/collection/collection_preview.dart';

import 'edit_memory_page.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(
            "Collections",
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/edit_collection',
                    arguments: EditCollectionArguments(
                      collection: Collection(),
                      onSave: (collection) {
                        print("New collection: $collection");
                        BlocProvider.of<CollectionsBloc>(context)
                            .add(CollectionsBlocLoadCollections(true));
                      },
                    ));
              },
            )
          ],
        ),
        Expanded(
            child: BlocConsumer<CollectionsBloc, CollectionsBlocState>(
          builder: (context, state) {
            if (state is CollectionsLoading) {
              return Center(child: Text("Loading"));
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: state.collections.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CollectionPreview(
                      collection: state.collections[index],
                      memories: state.memories,
                    ),
                  );
                },
              );
            }
          },
          listener: (context, state) {
            if (state is CollectionsError) {
              print(state.errorCode);
            }
          },
        ))
      ],
    );
  }
}
