# MemorMe v0.12

This is the Android Flutter project for MemorMe.

This is the simply-featured offline version, providing basic functionality:
* User can create memories using text and photo stories
* User can create simple collections from memories
* User can search for memories and collections
* User can easily view past memories and collections

It is also hooked up with Firebase Analytics and Crashlytics.

## To Run
The Dart and Flutters tools in VSCode are fantastic, so open this project in there and install the Dart and Flutter VSCode extensions and then let it pull the required packges for the project (it'll automatically run `flutter pub get`).
Make sure you have the Android SDK installed and either a connected Android device or an emulator setup.
Then, in the `/lib` directory, open up `main.dart` and click `Run` above the `main` function, and choose the device you want to launch it on.

## Organization
All of the important code is located in the `/lib` directory.
Here, we've organized our code into `../data`, `../logic`, `../pages`, `../presentation`, and `../widgets` directories.

The *data* and *logic* folders contain the Dart business logic code, while the *pages*, *presentation*, and *widgets* folders contain the Flutter code that makes the app look good and react well.

The *data* folder contains our data models, provider classes, and repositories.

The *logic* folder contains our Business Logic Components (BLoCs), which hold our business logic relating to the way the data is changed.

The *pages* folder contains the pages of the app.

The *presentation* folder contains theming, icons, and router code.

The *widgets* folder contains the smaller components that make up the pages.

One should start in the `/lib/main.dart` file.

## Tests
Early on in our development, we were making use of test driven development.
As we continued, with our small team and need for rapid prototyping, we decided to abandon it.
As such, most of the tests are not working. They are located in the `/test` directory.
