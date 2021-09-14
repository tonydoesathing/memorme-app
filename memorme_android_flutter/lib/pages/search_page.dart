import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/logic/search_bloc/search_bloc.dart';
import 'package:memorme_android_flutter/pages/view_collection_page.dart';
import 'package:memorme_android_flutter/pages/view_memory_page.dart';
import 'package:memorme_android_flutter/widgets/collection/collection_preview.dart';
import 'package:memorme_android_flutter/widgets/memory/memory_preview.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchBlocState>(
      builder: (context, state) {
        return Column(
          children: [
            AppBar(
              title: Text(
                "Search",
              ),
            ),
            Expanded(
                child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus.unfocus();
              },
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: state.results.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 20.0, left: 8.0, right: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.search,
                            onEditingComplete: () {
                              FocusManager.instance.primaryFocus.unfocus();
                            },
                            onChanged: (value) {
                              BlocProvider.of<SearchBloc>(context)
                                  .add(SearchBlocSearch(value));
                            },
                            initialValue: state.query,
                            decoration: InputDecoration(
                                hintText: "Search...",
                                suffixIcon: Icon(Icons.search)),
                          ),
                        ),
                      ),
                    );
                  } else {
                    Object result = state.results[index - 1].object;
                    if (result is Collection) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/view_collection",
                                arguments: ViewCollectionArguments(
                                    collection: result));
                          },
                          child: CollectionPreview(
                            collection: result,
                            memories: state.collectionMemories[result.id],
                            repository: BlocProvider.of<SearchBloc>(context)
                                .collectionRepository,
                          ),
                        ),
                      );
                    } else if (result is Memory) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/view_memory",
                                    arguments: ViewMemoryPageArguments(result));
                              },
                              child: MemoryPreview(
                                  width: 240 * 0.8, memory: result)),
                        ),
                      );
                    } else {
                      return ListTile(
                        title: Text("No preview for this item"),
                      );
                    }
                  }
                },
              ),
            ))
          ],
        );
      },
      listener: (context, state) {
        if (state is SearchBlocError) {
          print(state.error);
        }
      },
    );
  }
}
