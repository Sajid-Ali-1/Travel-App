import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await AppTheme.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode _themeMode = AppTheme.themeMode;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'First Montana Title App',
        theme: ThemeData(brightness: Brightness.light, useMaterial3: false),
        darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: false),
        themeMode: ThemeMode.light,
        defaultTransition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        home: HomeScreen(),
      ),
    );
  }
}
