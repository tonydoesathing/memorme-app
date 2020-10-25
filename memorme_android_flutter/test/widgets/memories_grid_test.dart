import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/models/memory.dart';
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
      memories.add(Memory(media: ["1", "2"], stories: ["story 1", "story 2"]));
      memories.add(Memory(
          media: ["1", "2", "3"], stories: ["story 1", "story 2", "story 3"]));

      await tester.pumpWidget(makeTestable(MemoriesGrid(
        memories: memories,
      )));

      //expect to find two images
      expect(find.byType(Image), findsNWidgets(2));
    });
  });
}
