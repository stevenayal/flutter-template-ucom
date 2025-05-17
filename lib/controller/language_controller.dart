import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  final RxString currentLanguage = 'es_ES'.obs;

  @override
  void onInit() {
    super.onInit();
    changeLanguage('es_ES');
  }

  void changeLanguage(String languageCode) {
    currentLanguage.value = languageCode;
    Get.updateLocale(Locale(languageCode.split('_')[0], languageCode.split('_')[1]));
  }
} 