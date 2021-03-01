import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/widgets/memories_list_horizontal.dart';
import 'package:memorme_android_flutter/widgets/memory_display.dart';

import '../utils/widget_test_utils.dart';

//TODO: [MMA-107] Fix memories_list test

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
      memories.add(Memory(id: null, dateCreated: 1, dateLastEdited: 1, storyPreviewId: 1, stories: [
        Story(id: 1, dateCreated: 1, dateLastEdited: 1, data: "Story 1!", type: StoryType.TEXT_STORY),
        Story(id: 2, dateCreated: 1, dateLastEdited: 1, data: "Story 2!", type: StoryType.TEXT_STORY)
      ]));
      memories.add(Memory(id: null, dateCreated: 2, dateLastEdited: 2, storyPreviewId: 2, stories: 
          [Story(id: 1, dateCreated: 1, dateLastEdited: 1, data: "Story 1!", type: StoryType.TEXT_STORY)]));

      await tester.pumpWidget(makeTestable(MemoriesList(
        memories: memories,
      )));

      //expect to find two images
      expect(find.byType(MemoryDisplay), findsNWidgets(2));
    });
  });
}
