import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/widgets/BottomNavBar.dart';

import 'edit_memory_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(
            "Home",
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
