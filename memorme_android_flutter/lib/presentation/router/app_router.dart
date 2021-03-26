import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/providers/sqlite_db_provider.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/local_collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/local_memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/sqlite_memory_repository.dart';
import 'package:memorme_android_flutter/logic/collections_bloc/collections_bloc.dart';
import 'package:memorme_android_flutter/logic/edit_collection_bloc/edit_collection_bloc.dart';
import 'package:memorme_android_flutter/logic/edit_memory_bloc/edit_memory_bloc.dart';
import 'package:memorme_android_flutter/logic/memories_bloc/memories_bloc.dart';
import 'package:memorme_android_flutter/logic/select_memories_bloc/select_memories_bloc.dart';
import 'package:memorme_android_flutter/logic/view_collection_bloc/view_collection_bloc.dart';
import 'package:memorme_android_flutter/pages/select_memories_page.dart';
import 'package:memorme_android_flutter/pages/top_level_page.dart';
import 'package:memorme_android_flutter/pages/collections_page.dart';
import 'package:memorme_android_flutter/pages/edit_collection_page.dart';
import 'package:memorme_android_flutter/pages/memories_page.dart';
import 'package:memorme_android_flutter/pages/display_memories_list.dart';
import 'package:memorme_android_flutter/pages/edit_memory_page.dart';
import 'package:memorme_android_flutter/pages/home_page.dart';
import 'package:memorme_android_flutter/pages/search_page.dart';
import 'package:memorme_android_flutter/pages/take_picture_page.dart';
import 'package:memorme_android_flutter/pages/view_collection_page.dart';
import 'package:memorme_android_flutter/pages/view_memory_page.dart';
import 'package:memorme_android_flutter/widgets/memories_list_horizontal.dart';

class AppRouter {
  MemoryRepository _memoryRepository;
  CollectionRepository _collectionRepository;

  AppRouter() {
    _memoryRepository = LocalMemoryRepository();
    _collectionRepository = LocalCollectionRepository();
  }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => MultiRepositoryProvider(providers: [
                  RepositoryProvider<MemoryRepository>.value(
                      value: _memoryRepository),
                  RepositoryProvider<CollectionRepository>.value(
                      value: _collectionRepository),
                ], child: TopLevelPage()));
      case '/view_memory':
        ViewMemoryPageArguments arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return ViewMemoryPage(arguments.memory);
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
                  create: (context) => EditMemoryBloc(_memoryRepository,
                      memory: arguments.memory),
                  child: EditMemoryPage(
                    onSave: arguments.onSave,
                  ),
                ));

      case '/edit_collection':
        EditCollectionArguments arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => EditCollectionBloc(
                      _collectionRepository, _memoryRepository,
                      collection: arguments.collection)
                    ..add(EditCollectionBlocLoadCollection(true)),
                  child: EditCollectionPage(
                    onSave: arguments.onSave,
                  ),
                ));

      case '/view_collection':
        ViewCollectionArguments arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ViewCollectionBloc(_collectionRepository,
                      _memoryRepository, arguments.collection)
                    ..add(ViewCollectionBlocLoadMemories(true)),
                  child: ViewCollectionPage(),
                ));
      case '/select_memories':
        SelectMemoriesPageArguments arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => SelectMemoriesBloc(_memoryRepository)
                    ..add(SelectMemoriesBlocLoadMemories(true)),
                  child: SelectMemoriesPage(
                    onSave: arguments.onSave,
                  ),
                ));
    }
  }

  void dispose() {}
}
