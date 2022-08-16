import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/logic/collections_bloc/collections_bloc.dart';
import 'package:memorme_android_flutter/pages/edit_collection_page.dart';
import 'package:memorme_android_flutter/pages/view_collection_page.dart';
import 'package:memorme_android_flutter/widgets/collection/collection_preview.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({Key key}) : super(key: key);

  @override
  _CollectionsPageState createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        // load more if there's more
        BlocProvider.of<CollectionsBloc>(context)
            .add(CollectionsBlocLoadCollections(false));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                        // BlocProvider.of<CollectionsBloc>(context)
                        //     .add(CollectionsBlocLoadCollections(true));
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
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CollectionPreview(
                      collection: state.collections[index],
                      memories:
                          state.collectionsMemories[state.collections[index]],
                      onTap: (collection) {
                        Navigator.pushNamed(context, '/view_collection',
                            arguments: ViewCollectionArguments(
                              collection: collection,
                            ));
                      },
                      repository: BlocProvider.of<CollectionsBloc>(context)
                          .collectionsRepository,
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
