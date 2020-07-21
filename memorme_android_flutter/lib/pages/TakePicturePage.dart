import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<List<CameraDescription>> loadCameras() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  return cameras;
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

  void switchCamera() {
    setState(() {
      activeCamera = (activeCamera + 1) % cameras.length;
      _initializeControllerFuture = initCameraController();
    });
  }

  initCameraController() async {
    cameras = await loadCameras();
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
        title: Text('Take a picture'),
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
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          //try and take the photo then go to the DisplayMemoryPage
          try {
            await _initializeControllerFuture;

            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            await _controller.takePicture(path);

            widget.takePictureCallback(path);
          } catch (e) {
            print(e);
          }
        },
      ),
      persistentFooterButtons: <Widget>[
        RaisedButton(
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
