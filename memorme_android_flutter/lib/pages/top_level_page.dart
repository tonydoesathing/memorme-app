import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/logic/collections_bloc/collections_bloc.dart';
import 'package:memorme_android_flutter/logic/memories_bloc/memories_bloc.dart';
import 'package:memorme_android_flutter/pages/collections_page.dart';
import 'package:memorme_android_flutter/pages/home_page.dart';
import 'package:memorme_android_flutter/pages/memories_page.dart';
import 'package:memorme_android_flutter/pages/search_page.dart';
import 'package:memorme_android_flutter/widgets/BottomNavBar.dart';

import 'edit_memory_page.dart';

/// This page contains all of the top-level pages with the navigation bar
/// (e.g. Home, Search, Collections, Memories)
class TopLevelPage extends StatefulWidget {
  const TopLevelPage({Key key}) : super(key: key);

  @override
  _TopLevelPageState createState() => _TopLevelPageState();
}

class _TopLevelPageState extends State<TopLevelPage> {
  PageController _pageController;
  int _focusedTab = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  // when we change pages, we need to update the NavBar's focused tab
  void onPageChanged(int index) {
    setState(() {
      _focusedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: [
            // these are our main pages
            HomePage(),
            SearchPage(),
            BlocProvider.value(
              value: BlocProvider.of<CollectionsBloc>(context),
              child: CollectionsPage(),
            ),
            BlocProvider.value(
              value: BlocProvider.of<MemoriesBloc>(context),
              child: MemoriesPage(),
            )
          ],
        ),
        // the following is the bottom nav bar
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          key: Key("AddMemoryFAB"),
          onPressed: () {
            //display memory UI
            Navigator.pushNamed(context, '/edit_memory',
                arguments: EditMemoryArguments(onSave: (memory) {}));
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavBar(
          focusedTab: _focusedTab,
          onPressed: (value) {
            // when we press a button, navigate to the associated page
            _pageController.animateToPage(value,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
        ));
  }
}