import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/presentation/router/app_router.dart';
import 'package:memorme_android_flutter/presentation/theme/memorme_theme.dart';

main() {
  runApp(MemorMe());
}

class MemorMe extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: MemorMeTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRouter.onGenerateRoute);
  }

  void dispose() {
    _appRouter.dispose();
  }
}
