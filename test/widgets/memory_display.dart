import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';

void main() {
  group("Memories List test", () {
    const List<Memory> memories = [
      Memory(
          id: 1,
          dateCreated: 1,
          dateLastEdited: 1,
          storyPreviewId: 1,
          stories: [
            Story(
                id: 1,
                dateCreated: 1,
                dateLastEdited: 1,
                data: "Story 1!",
                type: StoryType.TEXT_STORY)
          ]),
      Memory(
          id: 2,
          dateCreated: 2,
          dateLastEdited: 2,
          storyPreviewId: 2,
          stories: [
            Story(
                id: 2,
                dateCreated: 2,
                dateLastEdited: 2,
                data: "Story 2!",
                type: StoryType.TEXT_STORY)
          ]),
      Memory(
          id: 3,
          dateCreated: 3,
          dateLastEdited: 3,
          storyPreviewId: 4,
          stories: [
            Story(
                id: 3,
                dateCreated: 3,
                dateLastEdited: 3,
                data: "Story 3!",
                type: StoryType.TEXT_STORY),
            Story(
                id: 4,
                dateCreated: 3,
                dateLastEdited: 3,
                data: "Story 4!",
                type: StoryType.TEXT_STORY)
          ]),
    ];

    testWidgets('Should start with zero stories in empty memory',
        (WidgetTester tester) async {
      //await tester.pumpWidget(makeTestable(MemoryDisplay()));
    });
  });
}
