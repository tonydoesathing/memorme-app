import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/providers/sqlite_db_provider.dart';
import 'package:memorme_android_flutter/data/repositories/local_memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/sqlite_memory_repository.dart';
import 'package:memorme_android_flutter/logic/edit_memory_bloc/edit_memory_bloc.dart';
import 'package:memorme_android_flutter/logic/memories_bloc/memories_bloc.dart';
import 'package:memorme_android_flutter/pages/display_memories_grid.dart';
import 'package:memorme_android_flutter/pages/display_memories_list.dart';
import 'package:memorme_android_flutter/pages/edit_memory_page.dart';
import 'package:memorme_android_flutter/pages/take_picture_page.dart';
import 'package:memorme_android_flutter/widgets/memories_list_horizontal.dart';

class AppRouter {
  LocalMemoryRepository _memoryRepository;
  MemoriesBloc _memoriesBloc;

  AppRouter() {
    _memoryRepository = LocalMemoryRepository();
    _memoriesBloc = MemoriesBloc(_memoryRepository);
    _memoriesBloc.add(MemoriesBlocLoadMemories(true));
  }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _memoriesBloc,
            child: DisplayMemoriesGrid(),
          ),
        );
      case '/display_memory_list':
        MemoriesListArguments arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider.value(
              value: _memoriesBloc,
              child: DisplayMemoriesList(focusedIndex: arguments.focusedIndex),
            );
          },
        );
      case '/take_picture':
        TakePictureArguments arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => TakePictureScreen(
                takePictureCallback: arguments.takePictureCallback));

      case '/edit_memory':
        EditMemoryArguments arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => EditMemoryBloc(
                      _memoryRepository, _memoriesBloc,
                      memory: arguments.memory),
                  child: EditMemoryPage(
                    onSave: arguments.onSave,
                  ),
                ));
    }
  }

  void dispose() {}
}
