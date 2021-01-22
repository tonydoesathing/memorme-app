import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/widget_test_utils.dart';

main() {
  /*group("DisplayMemoriesPage test >", () {
    testWidgets("Should list all memories in a grid",
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestable(
        DisplayMemoriesPage(testing: true),
      ));
      expect(find.byKey(Key("MemoriesGridTile")), findsNothing);
      Finder fab = find.byKey(Key("AddMemoryFAB"));
      expect(fab, findsOneWidget);
      await tester.tap(fab);
      await tester.pump();
      await tester.tap(fab);
      await tester.pump();
      await tester.tap(fab);
      await tester.pump();
      expect(find.byKey(Key("MemoriesGridTile")), findsNWidgets(3));
    });
    testWidgets("Should be able to create a memory",
        (WidgetTester tester) async {
      //load a frame of the DisplayMemoriesPage
      await tester.pumpWidget(makeTestable(
        DisplayMemoriesPage(testing: true),
      ));
      expect(find.byKey(Key("MemoriesGridTile")), findsNothing);
      //Find and tap the FAB then load a frame
      Finder fab = find.byKey(Key("AddMemoryFAB"));
      expect(fab, findsOneWidget);
      await tester.tap(fab);
      await tester.pump();
      //it should've added another memory to the list
      expect(find.byKey(Key("MemoriesGridTile")), findsOneWidget);
    });
  });*/
}
