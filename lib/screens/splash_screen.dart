import 'package:flutter/material.dart';
import 'package:imagescanner/lang/locale_keys.g.dart';
import 'package:imagescanner/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate an initialization process, like loading preferences or checking authentication
    _initializeApp();
  }

  void _initializeApp() async {
    // Simulate loading preferences
    await Future.delayed(const Duration(seconds: 3));

    // Navigate to the main app screen
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(title: LocaleKeys.appTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlutterLogo(size: 150),
          ],
        ),
      ),
    );
  }
}
