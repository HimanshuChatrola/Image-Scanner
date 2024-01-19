import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color appBarColor = Color(0xFF081B4C);
  static const Color colorWhite = Colors.white;
  static const Color colorBlack = Colors.black;
  static const Color colorGrey = Color.fromARGB(255, 114, 109, 109);
  static const Color colorAquamarin = Color.fromARGB(255, 38, 160, 194);
  static const Color colorLightRed = Color.fromARGB(255, 249, 173, 153);
}

abstract class SharedPreferencesKeys {
  static const isLogin = 'isLogin';
}

abstract class ImageConstants {
  static const String imagePath = 'assets/image';
  static const String icnSplashImages = '$imagePath/splash_images.png';
}
