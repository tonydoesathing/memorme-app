import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/presentation/router/app_router.dart';

main() {
  runApp(MemorMe());
}

class MemorMe extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  ThemeData memormeTheme = 
    ThemeData(
      primaryColor: Colors.white,
      accentColor: Colors.blue[400]
    );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: memormeTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRouter.onGenerateRoute);
  }

  void dispose() {
    _appRouter.dispose();
  }
}
