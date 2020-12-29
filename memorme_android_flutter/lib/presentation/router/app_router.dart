import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/pages/display_memories_page.dart';
import 'package:memorme_android_flutter/pages/edit_memory_page.dart';
import 'package:memorme_android_flutter/pages/take_picture_page.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => DisplayMemoriesPage());

      case '/take_picture':
        TakePictureArguments arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => TakePictureScreen(
                takePictureCallback: arguments.takePictureCallback));

      case '/edit_memory':
        EditMemoryArguments arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => EditMemoryPage(onSave: arguments.onSave));
    }
  }

  void dispose() {}
}
