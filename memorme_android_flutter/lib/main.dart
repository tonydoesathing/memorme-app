import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/pages/display_memory_page.dart';

import 'pages/display_memories_page.dart';

main() {
  runApp(MaterialApp(
    theme: ThemeData.light(),
    home: DisplayMemoriesPage(),
    debugShowCheckedModeBanner: false,
  ));
}
