import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/widgets/BottomNavBar.dart';
import 'package:memorme_android_flutter/widgets/memory/memory_preview.dart';

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
            child: GridView.count(
                padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                    ((MediaQuery.of(context).size.width / 2) +
                        8.0 +
                        23.0), //height = (width) + padding on top of text + textheight
                children: List.generate(
                  6,
                  (index) => MemoryPreview(
                    memory: Memory(title: "Me and My Walrus", stories: [
                      Story(
                          type: StoryType.TEXT_STORY,
                          data:
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer commodo porta ipsum, id maximus urna. Praesent nec pulvinar metus, quis fermentum augue. Etiam vel facilisis justo, at vestibulum turpis. Curabitur ut arcu pretium, tincidunt ante ut, suscipit nisi. Nulla aliquam erat dapibus, bibendum augue in, dignissim velit. In eget lectus sollicitudin, fermentum odio et, lobortis nisi. Ut egestas est vel tellus fermentum, vel dictum dui pharetra. Mauris porttitor ornare enim vitae aliquam. Ut rhoncus nisl sem, interdum feugiat odio suscipit nec. Etiam sed augue sed ligula suscipit molestie pulvinar a mi. Morbi volutpat dolor id purus eleifend, at rhoncus metus placerat. Nulla lobortis laoreet risus, vitae auctor lacus porta non. Duis consequat luctus neque, eu varius nibh fermentum ut.")
                    ]),
                  ),
                )))
      ],
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
    );
  }
}
