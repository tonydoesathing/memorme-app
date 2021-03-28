import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/providers/analytics_provider.dart';
import 'package:memorme_android_flutter/presentation/router/app_router.dart';
import 'package:memorme_android_flutter/presentation/theme/memorme_theme.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MemorMe());
}

class MemorMe extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();
  final FirebaseAnalyticsObserver _observer =
      FirebaseAnalyticsObserver(analytics: AnalyticsProvider().analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: MemorMeTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          _observer,
        ],
        onGenerateRoute: _appRouter.onGenerateRoute);
  }

  void dispose() {
    _appRouter.dispose();
  }
}
