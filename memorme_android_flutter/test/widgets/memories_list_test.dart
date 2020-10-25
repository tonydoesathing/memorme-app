import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/models/memory.dart';
import 'package:memorme_android_flutter/widgets/memories_grid.dart';
import 'package:memorme_android_flutter/widgets/memories_list.dart';
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
      memories.add(Memory(media: ["1", "2"], stories: ["story 1", "story 2"]));
      memories.add(Memory(
          media: ["1", "2", "3"], stories: ["story 1", "story 2", "story 3"]));

      await tester.pumpWidget(makeTestable(MemoriesList(
        memories: memories,
      )));

      //expect to find two images
      expect(find.byType(MemoryDisplay), findsNWidgets(2));
    });
  });
}
