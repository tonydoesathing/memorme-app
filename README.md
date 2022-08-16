<p align="center">
    <img src="assets/graphics/MemorMeLogo.png"
        height="130">
</p>

# MemorMe

<a href="https://www.flutter.org/" alt="Flutter"><img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" /></a> 
<a href="https://github.com/tonydoesathing/memorme-app/releases" alt="Figma"><img src="https://img.shields.io/github/v/release/tonydoesathing/memorme-app" /></a>
<a href="https://github.com/tonydoesathing/memorme-app" alt="Figma"><img src="https://img.shields.io/github/last-commit/tonydoesathing/memorme-app" /></a>

MemorMe is an Android app that removes the physical burden of remembering what's important.


<p align="center">
    <img src="assets/readme/memorme_example.gif" height=500>
</p>

## Features
* Create memories using text and photo stories
* Create simple collections to organize your memories
* Easily search for and find collections and memories
* Revisit your memories to always keep them with you

## To Build
With Dart, Flutter, and Android Studio set up, run `flutter pub get` in the project directory, followed by `flutter build apk`. 



## Organization
All of the important code is located in the `/lib` directory.
Here, we've organized our code into `data`, `logic`, `pages`, `presentation`, and `widgets` directories.

The *data* and *logic* folders contain the Dart business logic code, while the *pages*, *presentation*, and *widgets* folders contain the Flutter code that makes the app look good and react well.

The *data* folder contains our `Memory` and `Collection` data models, provider classes, and repositories.

The *logic* folder contains our Business Logic Components (BLoCs), which hold our business logic relating to the way the data is changed.

The *pages* folder contains the pages of the app.

The *presentation* folder contains theming, icons, and router code.

The *widgets* folder contains the smaller components that make up the pages.

One should start in the `/lib/main.dart` file.

## Tests
Early on in our development, we were making use of test driven development.
As we continued, our small team decided to focus on rapid prototyping and decided to abandon it.
As such, most of the tests are not up to date or passing. They are located in the `/test` directory.

## Libraries and Tools
MemorMe uses [bloc](https://bloclibrary.dev/#/) & [SQFlite](https://pub.dev/packages/sqflite) for state management and [Firebase Analytics](https://pub.dev/packages/firebase_analytics) & [Firebase Crashalytics](https://pub.dev/packages/firebase_crashlytics) for analytics and monitoring.