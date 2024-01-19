import 'dart:ui';

import 'package:get/get.dart';
import 'en_Us.dart';

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static final fallbackLocale = Get.locale;

  @override
  Map<String, Map<String, String>> get keys => {'en_US': en_Us};
}
