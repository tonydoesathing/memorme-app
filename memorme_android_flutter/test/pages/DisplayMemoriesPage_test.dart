import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/pages/DisplayMemoriesPage.dart';

Widget makeTestable(Widget child) {
  return MaterialApp(
    home: child,
  );
}

main() {
  group("DisplayMemoriesPage test >", () {
    testWidgets("Should be able to create a memory and list memories",
        (WidgetTester tester) async {
      //load a frame of the DisplayMemoriesPage
      await tester.pumpWidget(makeTestable(
        DisplayMemoriesPage(testing: true),
      ));
      expect(find.byKey(Key("MemoriesListTile")), findsNothing);
      //Find and tap the FAB then load a frame
      Finder fab = find.byKey(Key("AddMemoryFAB"));
      expect(fab, findsOneWidget);
      await tester.tap(fab);
      await tester.pump();
      //it should've added another memory to the list
      expect(find.byKey(Key("MemoriesListTile")), findsOneWidget);
    });
  });
}
