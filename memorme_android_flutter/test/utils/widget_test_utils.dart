import 'package:flutter/material.dart';

MaterialApp makeTestable(Widget w) {
  return MaterialApp(
    home: Scaffold(
      body: w,
    ),
  );
}
