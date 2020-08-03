import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/widgets/fullscreen_text_field.dart';

MaterialApp makeTestable(Widget w){
  return MaterialApp(home: w);
}

main(){
  group("FullscreenTextField test", () {
    testWidgets("Should be able to edit text",
      (WidgetTester tester) async{
        String story = 'meow';
        await tester.pumpWidget(makeTestable(
          FullscreenTextField(
            text: story, 
            onSave: (val) {
              if (story != val) {
                story = val;
              }
            }
          )
        ));
        Finder textfield = find.byKey(Key('Textfield'));
        Finder checkicon = find.byKey(Key('Check_icon'));

        // controller is not a widget, cannot test its value
        // Finder controller = find.bySemanticsLabel('_controller');
        // expect(controller, 'meow');
        
        await tester.enterText(textfield, 'hallo');
        await tester.tap(checkicon);

        expect(story, 'hallo');

      });
  });
}