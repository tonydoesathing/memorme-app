import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/widgets/memories_list_horizontal.dart';
import 'package:memorme_android_flutter/widgets/memory_display.dart';

import '../utils/widget_test_utils.dart';

void main() {
  group("Memories List test", () {
    testWidgets('Should start with zero memory widgets in empty list',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestable(MemoriesList()));

      //expect to find no memory displays
      expect(find.byType(MemoryDisplay), findsNothing);
    });

    testWidgets(
        'Should start with number of memory widgets equal to memories in list',
        (WidgetTester tester) async {
      List<Memory> memories = [];
      memories.add(Memory(null, 1, 1, 1, [
        Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY),
        Story(2, 1, 1, "Story 2", StoryType.TEXT_STORY)
      ]));
      memories.add(Memory(
          null, 2, 2, 2, [Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY)]));

      await tester.pumpWidget(makeTestable(MemoriesList(
        memories: memories,
      )));

      //expect to find two images
      expect(find.byType(MemoryDisplay), findsNWidgets(2));
    });
  });
}
