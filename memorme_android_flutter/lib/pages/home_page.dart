import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/logic/home_page_bloc/home_page_bloc.dart';
import 'package:memorme_android_flutter/pages/view_collection_page.dart';
import 'package:memorme_android_flutter/pages/view_memory_page.dart';
import 'package:memorme_android_flutter/widgets/BottomNavBar.dart';
import 'package:memorme_android_flutter/widgets/collection/collection_preview.dart';
import 'package:memorme_android_flutter/widgets/memory/memory_preview.dart';

import 'edit_memory_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _collectionsScroll = ScrollController();
  ScrollController _memoriesScroll = ScrollController();
  final _scrollThreshold = 100.0;

  @override
  void initState() {
    super.initState();
    _collectionsScroll.addListener(() {
      final maxScroll = _collectionsScroll.position.maxScrollExtent;
      final currentScroll = _collectionsScroll.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        // load more if there's more
        BlocProvider.of<HomePageBloc>(context)
            .add(HomePageBlocFetchCollections());
      }
    });
    _memoriesScroll.addListener(() {
      final maxScroll = _memoriesScroll.position.maxScrollExtent;
      final currentScroll = _memoriesScroll.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        // load more if there's more
        BlocProvider.of<HomePageBloc>(context).add(HomePageBlocFetchMemories());
      }
    });
  }

  @override
  void dispose() {
    _collectionsScroll.dispose();
    _memoriesScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageBlocState>(
      listener: (context, state) {
        if (state is HomePageBlocError) {
          print(state.error);
        }
      },
      builder: (context, state) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppBar(
            title: Text(
              "Home",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 8.0),
            child: Text(
              "Recent Collections",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(
            height: 240.0,
            child: ListView.builder(
              controller: _collectionsScroll,
              scrollDirection: Axis.horizontal,
              itemCount: state.collections.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: index == state.collections.length - 1
                      ? EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0)
                      : EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.93,
                    child: CollectionPreview(
                        onTap: (collection) {
                          Navigator.pushNamed(context, "/view_collection",
                              arguments: ViewCollectionArguments(
                                  collection: collection));
                        },
                        collection: state.collections[index],
                        memories: state
                            .collectionMemories[state.collections[index].id]),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 8.0),
            child: Text(
              "Recent Memories",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(
            height: 240.0,
            child: ListView.builder(
              controller: _memoriesScroll,
              scrollDirection: Axis.horizontal,
              itemCount: state.memories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: index == state.memories.length - 1
                      ? EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0)
                      : EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                  child: SizedBox(
                      width: 240 * 0.8,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/view_memory",
                                arguments: ViewMemoryPageArguments(
                                    state.memories[index]));
                          },
                          child: MemoryPreview(memory: state.memories[index]))),
                );
              },
            ),
          ),
          Expanded(
            child: Container(),
          )
        ]);
      },
    );

    // ListView.builder(
    //     padding: EdgeInsets.zero,
    //     itemCount: 5,
    //     itemBuilder: (context, index) {
    //       return MemoryPreview(memory: Memory(title: "$index"));
    //     },
    //   )
    // GridView.count(
    //           crossAxisCount: 1,
    //           children: List.generate(
    //             2,
    //             (index) => MemoryPreview(memory: Memory(title: "$index")),
    //           ))
  }
}
