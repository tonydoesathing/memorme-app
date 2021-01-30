import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memorme_android_flutter/data/providers/file_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<List<CameraDescription>> loadCameras() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  return cameras;
}

class TakePictureArguments {
  final Function takePictureCallback;

  TakePictureArguments(this.takePictureCallback);
}

class TakePictureScreen extends StatefulWidget {
  final void Function(String value) takePictureCallback;

  const TakePictureScreen({Key key, this.takePictureCallback})
      : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  List<CameraDescription> cameras;
  int activeCamera = 0;
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  final picker = ImagePicker();

  // Goes to the next camera
  void switchCamera() {
    setState(() {
      activeCamera = (activeCamera + 1) % cameras.length;
      _initializeControllerFuture = initCameraController();
    });
  }

  initCameraController() async {
    cameras = await loadCameras();
    // make sure we're loading on the back camera
    int i = 0;
    while (cameras[activeCamera].lensDirection != CameraLensDirection.back &&
        i < cameras.length) {
      activeCamera = (activeCamera + 1) % cameras.length;
      i++;
    }
    _controller = CameraController(
      cameras[activeCamera],
      ResolutionPreset.medium,
    );
    return _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initCameraController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        title: Text('Take a picture', style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: Key("TakePictureButton"),
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          //try and take the photo then go to the DisplayMemoryPage
          try {
            await _initializeControllerFuture;
            String path = await FileProvider().makeTempMediaPath(".png");
            //try to save the picture
            try {
              await _controller.takePicture(path);
            } catch (_) {
              // just print an error; should actually handle it
              print(_);
            }

            widget.takePictureCallback(path);
          } catch (e) {
            print(e);
          }
        },
      ),
      persistentFooterButtons: <Widget>[
        RaisedButton(
            key: Key("GalleryButton"),
            onPressed: () async {
              try {
                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);
                widget.takePictureCallback(pickedFile.path);
              } catch (e) {
                print(e);
              }
            },
            color: Colors.white,
            child: Icon(Icons.photo_library, color: Colors.blueAccent)),
        RaisedButton(
            key: Key("SwitchCameraButton"),
            onPressed: switchCamera,
            color: Colors.black,
            child: Icon(
              Icons.switch_camera,
              color: Colors.white,
            ))
      ],
    );
  }
}
