// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagescanner/lang/locale_keys.g.dart';
import 'package:imagescanner/lang/translation_service.dart';
import 'package:imagescanner/screens/take_photo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Locale currentLocale = const Locale('en', 'US');

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: TranslationService(),
      locale: currentLocale,
      title: LocaleKeys.appTitle.tr,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: widget.isLogin ? const SplashScreen() : const SplashScreen(),
      home: TakePhotoScreen(null, null),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Material();
  }
}
