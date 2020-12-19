import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/memory.dart';
import 'package:memorme_android_flutter/widgets/memory_display.dart';

import '../utils/widget_test_utils.dart';

void main() {
  group("Memory Display test", () {
    testWidgets('Should display even with improper image',
        (WidgetTester tester) async {
      Memory memory = Memory(["1", "2"], ["Story 1", "Story 2"]);
      await tester.pumpWidget(makeTestable(MemoryDisplay(memory)));

      //expect to find no memory displays
      expect(find.byType(MemoryDisplay), findsOneWidget);
    });
  });
}
