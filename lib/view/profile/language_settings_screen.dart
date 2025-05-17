import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(LanguageController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.isLightTheme == false
            ? HexColor('#15141f')
            : Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        title: Text(
          "language_settings".tr,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        color: AppTheme.isLightTheme == false
            ? HexColor('#15141f')
            : Theme.of(context).appBarTheme.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "select_language".tr,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 32),
              Obx(() => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          languageController.changeLanguage('es_ES');
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.isLightTheme == false
                                ? const Color(0xff323045)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: languageController.currentLanguage.value == 'es_ES'
                                  ? HexColor(AppTheme.primaryColorString!)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Español",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const Spacer(),
                              if (languageController.currentLanguage.value == 'es_ES')
                                Icon(
                                  Icons.check_circle,
                                  color: HexColor(AppTheme.primaryColorString!),
                                ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          languageController.changeLanguage('en_US');
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.isLightTheme == false
                                ? const Color(0xff323045)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: languageController.currentLanguage.value == 'en_US'
                                  ? HexColor(AppTheme.primaryColorString!)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "English",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const Spacer(),
                              if (languageController.currentLanguage.value == 'en_US')
                                Icon(
                                  Icons.check_circle,
                                  color: HexColor(AppTheme.primaryColorString!),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
} 