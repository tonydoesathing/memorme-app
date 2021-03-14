import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/presentation/theme/memorme_colors.dart';

class MemorMeTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      // primary color is MemorMe blue
      primaryColor: MemorMeColors.blue,
      // app bar is the background color and at 0 elevation by default
      appBarTheme: AppBarTheme(
          color: MemorMeColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: MemorMeColors.blue),
          // keep defaults, but change the title
          textTheme: TextTheme(
              headline6: Typography.material2018()
                  .englishLike
                  .headline6
                  .copyWith(color: MemorMeColors.blue))),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: MemorMeColors.blue,
          unselectedItemColor: MemorMeColors.darkGrey),

      /// the default background color of some widgets
      backgroundColor: MemorMeColors.background,

      /// the color of the app's general background
      canvasColor: MemorMeColors.background,

      // buttons are white
      buttonColor: Colors.white,
      textTheme: Typography.material2018().englishLike.copyWith(

          /// [button] is used for button text and button icon's color
          button: Typography.material2018()
              .englishLike
              .button
              .copyWith(color: MemorMeColors.blue),

          /// [bodyText2] is used for things like the text in [TextStoryItem]
          /// as well as the [FullscreenTextField]; it's the default text style
          /// for larger chunks of text
          bodyText2: Typography.material2018()
              .englishLike
              .bodyText2
              .copyWith(fontSize: 16.0),

          /// [subtitle1] is used for [ListTile.title] text
          subtitle1: Typography.material2018()
              .englishLike
              .subtitle1
              .copyWith(fontSize: 18)),

      /// the default text styles are coming from the Material 2018 specs
      typography: Typography.material2018(platform: TargetPlatform.android),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: MemorMeColors.blue),
    );
  }
}
