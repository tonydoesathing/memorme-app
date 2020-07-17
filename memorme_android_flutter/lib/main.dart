import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/pages/TakePicturePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(MaterialApp(
    theme: ThemeData.light(),
    home: TakePictureScreen(
      camera: firstCamera,
    ),
    debugShowCheckedModeBanner: false,
  ));
}
