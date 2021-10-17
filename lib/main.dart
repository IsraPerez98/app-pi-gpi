import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micu/screens/splash_screen.dart';
import 'package:micu/themes/theme.dart';
import './screens/main_screen.dart';

void main() {
  runApp(MicUApp());
}

class MicUApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'afantü',
      
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => SplashScreen()},
      theme: MainTheme.theme,
    );
  }
}
