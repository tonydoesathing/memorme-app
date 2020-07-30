import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/pages/DisplayMemoryPage.dart';

import 'pages/DisplayMemoriesPage.dart';

main() {
  runApp(MaterialApp(
    theme: ThemeData.light(),
    home: DisplayMemoriesPage(),
    debugShowCheckedModeBanner: false,
  ));
}
