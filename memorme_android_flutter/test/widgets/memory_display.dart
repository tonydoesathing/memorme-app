import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/widgets/memories_list_horizontal.dart';
import 'package:memorme_android_flutter/widgets/memory_display.dart';

import '../utils/widget_test_utils.dart';

void main() {
  group("Memories List test", () {

    const List<Memory> memories = [
      Memory(1, 1, 1, 1, [Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY)]),
      Memory(2, 2, 2, 2, [Story(2, 2, 2, "Story 2", StoryType.TEXT_STORY)]),
      Memory(3, 3, 3, 4, [
        Story(3, 3, 3, "Story 3", StoryType.TEXT_STORY),
        Story(4, 3, 3, "Story 4", StoryType.TEXT_STORY)
      ]),
    ];


    testWidgets('Should start with zero memory widgets in empty list',
        (WidgetTester tester) async {
      //await tester.pumpWidget(makeTestable(MemoryDisplay()));

    });
  });
}
