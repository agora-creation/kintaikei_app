import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/plan.dart';
import 'package:kintaikei_app/providers/plan_shift.dart';
import 'package:kintaikei_app/providers/work.dart';
import 'package:kintaikei_app/screens/home.dart';
import 'package:kintaikei_app/screens/login.dart';
import 'package:kintaikei_app/screens/splash.dart';
import 'package:kintaikei_app/services/fm.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyA6g3sR3HOBqXV5ei68z0S4OSWEzAGoFl0',
            appId: '1:50104600007:android:e13dbee897711b2f0745e2',
            messagingSenderId: '50104600007',
            projectId: 'kintaikei-project',
          ),
        )
      : await Firebase.initializeApp();
  await FmService().initNotifications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginProvider.initialize()),
        ChangeNotifierProvider.value(value: HomeProvider()),
        ChangeNotifierProvider.value(value: WorkProvider()),
        ChangeNotifierProvider.value(value: PlanProvider()),
        ChangeNotifierProvider.value(value: PlanShiftProvider()),
      ],
      child: MediaQuery.withNoTextScaling(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            SfGlobalLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ja')],
          locale: const Locale('ja'),
          title: '勤怠計',
          theme: customTheme(),
          home: const SplashController(),
        ),
      ),
    );
  }
}

class SplashController extends StatelessWidget {
  const SplashController({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    switch (loginProvider.status) {
      case AuthStatus.uninitialized:
        return const SplashScreen();
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        return LoginScreen(
          loginProvider: loginProvider,
          homeProvider: homeProvider,
        );
      case AuthStatus.authenticated:
        return HomeScreen(
          loginProvider: loginProvider,
          homeProvider: homeProvider,
        );
      default:
        return LoginScreen(
          loginProvider: loginProvider,
          homeProvider: homeProvider,
        );
    }
  }
}
