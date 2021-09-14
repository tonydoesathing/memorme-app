import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository_event.dart';
import 'package:memorme_android_flutter/pages/edit_collection_page.dart';
import 'package:memorme_android_flutter/widgets/memory/memory_preview.dart';

class CollectionPreview extends StatelessWidget {
  final CollectionRepository repository;
  final Collection collection;
  final List<Memory> memories;
  final void Function(Collection collection) onTap;
  const CollectionPreview(
      {Key key,
      @required this.collection,
      @required this.memories,
      @required this.repository,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: this.onTap == null ? null : () => this.onTap(this.collection),
        child: Card(
          child: Column(
            children: [
              // top row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      collection.title ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 200,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.edit,
                                          color:
                                              Theme.of(context).primaryColor),
                                      title: Text("Edit Collection",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/edit_collection',
                                            arguments: EditCollectionArguments(
                                                collection: this.collection,
                                                onSave: (collection) {}));
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.delete_forever,
                                          color: Theme.of(context).errorColor),
                                      title: Text("Delete Collection",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .errorColor)),
                                      onTap: () {
                                        Navigator.pop(context);
                                        showDialog<bool>(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'This will delete the collection forever.\nContinue?'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Yes'),
                                                  onPressed: () {
                                                    // discard the collection
                                                    repository
                                                        .removeCollection(
                                                            collection)
                                                        .then((value) =>
                                                            repository.addEvent(
                                                                CollectionRepositoryRemoveCollection(
                                                                    value)));
                                                    // close the dialog and allow it to pop
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text('No'),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      }),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 8.0, bottom: 20.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int memoryWidth = 110;
                    int numMemories = min(constraints.maxWidth / (memoryWidth),
                            memories.length)
                        .floor();

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int i = 0; i < numMemories; i++)
                          SizedBox(
                            width: 110.0,
                            child: MemoryPreview(memory: memories[i]),
                          )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
