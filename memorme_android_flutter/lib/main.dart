import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/repositories/local_memory_repository.dart';
import 'package:memorme_android_flutter/logic/bloc/memories_bloc.dart';

import 'pages/display_memories_page.dart';

main() {
  runApp(MaterialApp(
    theme: ThemeData.light(),
    home: BlocProvider(
      create: (context) {
        MemoriesBloc memoriesBloc = MemoriesBloc(LocalMemoryRepository([]));
        memoriesBloc.add(MemoriesLoaded());
        return memoriesBloc;
      },
      child: DisplayMemoriesPage(),
    ),
    debugShowCheckedModeBanner: false,
  ));
}
