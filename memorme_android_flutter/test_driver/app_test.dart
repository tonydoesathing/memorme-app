// Imports the Flutter Driver API.
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
//import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Take Picture Page', () {
    final takePictureButton = find.byValueKey('TakePictureButton');
    final galleryButton = find.byValueKey('GalleryButton');
    final switchCameraButton = find.byValueKey('SwitchCameraButton');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('can take picture', () async {
      await driver.tap(takePictureButton);
      expect(1, 1);
    });

    test('can open image from gallery', () async {
      await driver.tap(galleryButton);
      await Process.run(
        'adb',
        <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
        runInShell: true,
      );
      expect(isPresent(galleryButton, driver), true);
    });
  });
}

isPresent(SerializableFinder byValueKey, FlutterDriver driver,
    {Duration timeout = const Duration(seconds: 1)}) async {
  try {
    await driver.waitFor(byValueKey, timeout: timeout);
    return true;
  } catch (exception) {
    return false;
  }
}
