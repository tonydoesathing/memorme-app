import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/widgets/memory/memory_preview.dart';

class CollectionPreview extends StatelessWidget {
  final Collection collection;
  final List<Memory> memories;
  final void Function(Collection collection) onTap;
  const CollectionPreview(
      {Key key, @required this.collection, @required this.memories, this.onTap})
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
                  IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
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
                // child: Row(
                //   children: [
                //     for (int i = 0;
                //         i < min(5, collection.mcRelations.length);
                //         i++)
                //       SizedBox(
                //         width: 110.0,
                //         child: MemoryPreview(
                //             memory: memories[collection.mcRelations[i].memoryID]),
                //       )
                //     // child: Row(
                //     //   mainAxisAlignment: MainAxisAlignment.start,
                //     //   children: [
                //     //     for (int i = 0;
                //     //         i < min(5, collection.mcRelations.length);
                //     //         i++)
                //     //       SizedBox(
                //     //         height: 50.0,
                //     //         child: MemoryPreview(
                //     //             memory: memories[collection.mcRelations[i].memoryID]),
                //     //       )
                //     //   ],
                //     // ),
                //   ],
                // ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
