import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:memorme_android_flutter/pages/take_picture_page.dart';

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  runApp(MaterialApp(
    theme: ThemeData.light(),
    home: TakePictureScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
