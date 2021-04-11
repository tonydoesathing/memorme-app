import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/logic/home_page_bloc/home_page_bloc.dart';
import 'package:memorme_android_flutter/pages/view_collection_page.dart';
import 'package:memorme_android_flutter/pages/view_memory_page.dart';
import 'package:memorme_android_flutter/presentation/theme/memorme_colors.dart';
import 'package:memorme_android_flutter/widgets/BottomNavBar.dart';
import 'package:memorme_android_flutter/widgets/collection/collection_preview.dart';
import 'package:memorme_android_flutter/widgets/memory/memory_preview.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final _url = "https://forms.gle/vJT1h7BwZMT3iACK9";

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

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

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
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 8.0),
                  child: Text(
                    "Recent Collections",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                SizedBox(
                  height: 240.0,
                  child: state.collections.length > 0
                      ? ListView.builder(
                          controller: _collectionsScroll,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.collections.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: index == state.collections.length - 1
                                  ? state.collections.length > 1
                                      ? EdgeInsets.only(
                                          right: 8.0, top: 8.0, bottom: 8.0)
                                      : EdgeInsets.all(8.0)
                                  : EdgeInsets.only(
                                      left: 8.0, top: 8.0, bottom: 8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.93,
                                child: CollectionPreview(
                                  onTap: (collection) {
                                    Navigator.pushNamed(
                                        context, "/view_collection",
                                        arguments: ViewCollectionArguments(
                                            collection: collection));
                                  },
                                  collection: state.collections[index],
                                  memories: state.collectionMemories[
                                      state.collections[index].id],
                                  repository:
                                      BlocProvider.of<HomePageBloc>(context)
                                          .collectionRepository,
                                ),
                              ),
                            );
                          },
                        )
                      : Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 16.0),
                          child: Container(
                            color: MemorMeColors.background,
                            child: Center(
                              child: Text(
                                  "No collections to display at this time"),
                            ),
                          ),
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
                  child: state.memories.length > 0
                      ? ListView.builder(
                          controller: _memoriesScroll,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.memories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: index == state.memories.length - 1
                                  ? EdgeInsets.only(
                                      right: 8.0, top: 8.0, bottom: 8.0)
                                  : EdgeInsets.only(
                                      left: 8.0, top: 8.0, bottom: 8.0),
                              child: SizedBox(
                                  width: 240 * 0.8,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "/view_memory",
                                            arguments: ViewMemoryPageArguments(
                                                state.memories[index]));
                                      },
                                      child: MemoryPreview(
                                          memory: state.memories[index]))),
                            );
                          },
                        )
                      : Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 16.0),
                          child: Container(
                            color: MemorMeColors.background,
                            child: Center(
                                child: Text(
                                    "No memories to display at this time")),
                          ),
                        ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, right: 8.0, top: 4.0),
                  child: Center(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.grey[400])),
                          onPressed: _launchURL,
                          child: Text("Send us feedback",
                              style: Theme.of(context).textTheme.subtitle2))),
                ),
              ],
            ),
          ),
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
