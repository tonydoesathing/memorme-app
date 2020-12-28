import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/widgets/memories_grid.dart';

import '../utils/widget_test_utils.dart';

void main() {
  group("Memories Grid test", () {
    testWidgets('Should start with zero grid squares in empty grid',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestable(MemoriesGrid()));

      //expect to find no images
      expect(find.byType(Image), findsNothing);
    });

    testWidgets(
        'Should start with number of grid squares equal to memories in list',
        (WidgetTester tester) async {
      List<Memory> memories = [];
      memories.add(Memory(null, 1, 1, 1, [
        Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY),
        Story(2, 1, 1, "Story 2", StoryType.TEXT_STORY)
      ]));
      memories.add(Memory(
          null, 2, 2, 2, [Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY)]));

      await tester.pumpWidget(makeTestable(MemoriesGrid(
        memories: memories,
      )));

      //expect to find two images
      expect(find.byType(Image), findsNWidgets(2));
    });
  });
}
