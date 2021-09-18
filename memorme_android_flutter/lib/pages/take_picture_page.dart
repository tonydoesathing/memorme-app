import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memorme_android_flutter/data/providers/file_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

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
  CameraDescription active;
  int activeCamera = 0;
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  final picker = ImagePicker();

  // Goes to the next camera
  void switchCamera() {
    if (active.lensDirection == CameraLensDirection.back) {
      active = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    } else {
      active = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    }
    _controller = CameraController(
      active,
      ResolutionPreset.high,
    );
    setState(() {
      _initializeControllerFuture = _controller.initialize();
    });
  }

  _init() async {
    cameras = await loadCameras();
    setState(() {
      active = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    });
    _controller = CameraController(
      active,
      ResolutionPreset.high,
    );
    return _controller.initialize();
  }

  @override
  void initState() {
    super.initState();

    _initializeControllerFuture = _init();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          /// holds the camera preview
          Expanded(
            /// stack is needed to put the raised button on top
            child: Stack(
              children: <Widget>[
                /// build the camera preview when we get it
                FutureBuilder(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_controller);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),

                /// place the close button in the top left
                Positioned(
                  left: 0,
                  top: 16,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.all(8),
                    elevation: 3,
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).textTheme.button.color,
                    ),
                    shape: CircleBorder(),
                  ),
                )
              ],
            ),
          ),

          /// action bar at the bottom
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.4)
                ])),

            /// place to hold the buttons
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /// gallery button
                  FlatButton(
                    onPressed: () async {
                      try {
                        final pickedFile =
                            await picker.getImage(source: ImageSource.gallery);
                        widget.takePictureCallback(pickedFile.path);
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Icon(
                      Icons.photo_library,
                      color: Theme.of(context).textTheme.button.color,
                    ),
                    color: Theme.of(context).buttonColor,
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                  ),

                  /// take picture button
                  FlatButton(
                    onPressed: () async {
                      //try and take the photo then go to the DisplayMemoryPage
                      try {
                        await _initializeControllerFuture;
                        String path =
                            await FileProvider().makeTempMediaPath(".png");
                        //try to save the picture
                        try {
                          DeviceOrientation captureOrientation;
                          NativeDeviceOrientation currentOrientation =
                              await NativeDeviceOrientationCommunicator()
                                  .orientation(useSensor: true);

                          // HACKY SOLUTION TO ORIENTATION CAPTURE. Also, landscape left and right are switched on purpose. If they fix it (either camera or native_device_orientation) the following code needs to be fixed too.
                          if (currentOrientation ==
                              NativeDeviceOrientation.landscapeLeft) {
                            captureOrientation =
                                DeviceOrientation.landscapeRight;
                          } else if (currentOrientation ==
                              NativeDeviceOrientation.landscapeRight) {
                            captureOrientation =
                                DeviceOrientation.landscapeLeft;
                          } else if (currentOrientation ==
                              NativeDeviceOrientation.portraitDown) {
                            captureOrientation = DeviceOrientation.portraitDown;
                          } else {
                            captureOrientation = DeviceOrientation.portraitUp;
                          }
                          _controller
                              .lockCaptureOrientation(captureOrientation);
                          XFile picFile = await _controller.takePicture();
                          _controller.unlockCaptureOrientation();
                          await picFile.saveTo(path);
                        } catch (_) {
                          // just print an error; should actually handle it
                          print(_);
                        }

                        widget.takePictureCallback(path);
                      } catch (e) {
                        print(e);
                      }
                    },
                    color: Theme.of(context).buttonColor,
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: EdgeInsets.all(32),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// switch camera button
                  FlatButton(
                    onPressed: switchCamera,
                    child: Icon(
                      Icons.switch_camera,
                      color: Theme.of(context).textTheme.button.color,
                    ),
                    color: Theme.of(context).buttonColor,
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
