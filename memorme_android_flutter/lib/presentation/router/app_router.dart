import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/providers/sqlite_db_provider.dart';
import 'package:memorme_android_flutter/data/repositories/sqlite_memory_repository.dart';
import 'package:memorme_android_flutter/logic/bloc/memories_bloc.dart';
import 'package:memorme_android_flutter/pages/display_memories_page.dart';
import 'package:memorme_android_flutter/pages/edit_memory_page.dart';
import 'package:memorme_android_flutter/pages/take_picture_page.dart';

class AppRouter {

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BlocProvider(
            create: (context) {
              MemoriesBloc memoriesBloc = MemoriesBloc(SQLiteMemoryRepository(
                  SQLiteDBProvider.memorMeSQLiteDBProvider()));
              memoriesBloc.add(MemoriesLoaded());
              return memoriesBloc;
            },
            child: DisplayMemoriesPage(),
          ),
        );

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
