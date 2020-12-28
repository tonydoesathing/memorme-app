import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/providers/sqlite_db_provider.dart';
import 'package:memorme_android_flutter/data/repositories/local_memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/sqlite_memory_repository.dart';
import 'package:memorme_android_flutter/logic/bloc/memories_bloc.dart';
import 'package:memorme_android_flutter/presentation/router/app_router.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'pages/display_memories_page.dart';

main() {
  runApp(MemorMe());
}

class MemorMe extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        home: BlocProvider(
          create: (context) {
            MemoriesBloc memoriesBloc = MemoriesBloc(SQLiteMemoryRepository(
                SQLiteDBProvider.memorMeSQLiteDBProvider()));
            memoriesBloc.add(MemoriesLoaded());
            return memoriesBloc;
          },
          child: DisplayMemoriesPage(),
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRouter.onGenerateRoute);
  }

  void dispose() {
    _appRouter.dispose();
  }
}
