import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/presentation/router/app_router.dart';

main() {
  runApp(MemorMe());
}

class MemorMe extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRouter.onGenerateRoute);
  }

  void dispose() {
    _appRouter.dispose();
  }
}
