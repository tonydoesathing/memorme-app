import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/widgets/BottomNavBar.dart';

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
        ),
        Expanded(
            child: Center(
          child: Text("Under Construction"),
        ))
      ],
    );
  }
}
