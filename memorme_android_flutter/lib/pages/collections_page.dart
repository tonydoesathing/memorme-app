import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/pages/edit_collection_page.dart';
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
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/edit_collection',
                    arguments: EditCollectionArguments(
                  onSave: (collection) {
                    print(collection);
                  },
                ));
              },
            )
          ],
        ),
        Expanded(
            child: Center(
          child: Text("Under Construction"),
        ))
      ],
    );
  }
}
