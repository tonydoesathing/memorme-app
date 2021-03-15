import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/widgets/BottomNavBar.dart';

import 'edit_memory_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(
            "Search",
          ),
        ),
        Expanded(
            child: Center(
          child: Text("Under Construction"),
        ))
      ],
    );
  }
}
