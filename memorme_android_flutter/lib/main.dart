import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/repositories/local_memory_repository.dart';
import 'package:memorme_android_flutter/logic/bloc/memories_bloc.dart';
import 'package:memorme_android_flutter/presentation/router/app_router.dart';

import 'pages/display_memories_page.dart';

main(){
  runApp(MemorMe());
}

class MemorMe extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context){
    return MaterialApp(
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
      onGenerateRoute: _appRouter.onGenerateRoute
    );
  }

  void dispose(){
    _appRouter.dispose();
  }

}
