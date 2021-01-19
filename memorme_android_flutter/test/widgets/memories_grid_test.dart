import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/widgets/memories_grid.dart';
import 'package:memorme_android_flutter/widgets/story_previews/text_story_preview.dart';

import '../utils/widget_test_utils.dart';

void main() {
  group("Memories Grid test", () {
    testWidgets('Should start with zero grid squares in empty grid',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestable(MemoriesGrid()));

      //expect to find no images
      expect(find.byType(TextStoryPreview), findsNothing);
    });

    testWidgets(
        'Should start with number of grid squares equal to memories in list',
        (WidgetTester tester) async {
      List<Memory> memories = [];
      memories.add(Memory(id: null, dateCreated: 1, dateLastEdited: 1, storyPreviewId: 1, stories: [
        Story(id: 1, dateCreated: 1, dateLastEdited: 1, data: "Story 1!", type: StoryType.TEXT_STORY),
        Story(id: 2, dateCreated: 1, dateLastEdited: 1, data: "Story 2!", type: StoryType.TEXT_STORY)
      ]));
      memories.add(Memory(id: null, dateCreated: 2, dateLastEdited: 2, storyPreviewId: 2, stories: 
        [Story(id: 1, dateCreated: 1, dateLastEdited: 1, data: "Story 1!", type: StoryType.TEXT_STORY)]));

      await tester.pumpWidget(makeTestable(MemoriesGrid(
        memories: memories,
      )));

      //expect to find two images
      expect(find.byType(TextStoryPreview), findsNWidgets(2));
    });
  });
}
