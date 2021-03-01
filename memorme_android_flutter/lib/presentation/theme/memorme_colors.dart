import 'package:flutter/material.dart';

class MemorMeColors {
  /// The classic MemorMe blue
  static const Color blue = MaterialColor(_bluePrimaryValue, <int, Color>{
    50: Color(0xFFE0F3FF),
    100: Color(0xFFB3E2FF),
    200: Color(0xFF80CFFF),
    300: Color(0xFF4DBCFF),
    400: Color(0xFF26ADFF),
    500: Color(_bluePrimaryValue),
    600: Color(0xFF0097FF),
    700: Color(0xFF008DFF),
    800: Color(0xFF0083FF),
    900: Color(0xFF0072FF),
  }); //Color(0xFF009FFF);
  static const int _bluePrimaryValue = 0xFF009FFF;

  static const Color background = Color(0xFFF7F7F7);

  /// The black to go with our theme
  static const Color black = Color(0xFF00101A);
}
