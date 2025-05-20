// ignore_for_file: library_private_types_in_public_api

import 'package:finpay/config/textstyle.dart';
import 'package:finpay/config/translation.dart';
import 'package:finpay/view/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:finpay/controller/language_controller.dart';
import 'package:finpay/alumno/view/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor:
            Colors.transparent //or set color with: Color(0xFF0000FF)
        ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static setCustomeTheme(BuildContext context, int index) async {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();

    state!.setCustomeTheme(index);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  setCustomeTheme(int index) {
    if (index == 6) {
      setState(() {
        AppTheme.isLightTheme = true;
      });
    } else if (index == 7) {
      setState(() {
        AppTheme.isLightTheme = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.getTheme().primaryColor,
      systemNavigationBarDividerColor: AppTheme.getTheme().disabledColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    Get.put(LanguageController());

    return GetMaterialApp(
      title: 'FinPay',
      theme: AppTheme.getTheme(),
      debugShowCheckedModeBanner: false,
      translations: Translation(),
      locale: const Locale('es', 'ES'),
      fallbackLocale: const Locale('en', 'US'),
      home: LoginScreen(),
    );
  }
}
