import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/pages/DisplayMemoryPage.dart';
import 'package:memorme_android_flutter/pages/TakePicturePage.dart';

Future<void> main() async {
  runApp(MaterialApp(
    theme: ThemeData.light(),
    //home: TakePictureScreen(takePictureCallback: (path) => print(path)),
    home: DisplayMemoryPage(),
    debugShowCheckedModeBanner: false,
  ));
}
