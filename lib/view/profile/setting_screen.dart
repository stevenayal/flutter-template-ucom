// ignore_for_file: deprecated_member_use

import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/profile_controller.dart';
import 'package:finpay/main.dart';
import 'package:finpay/view/profile/notification_screen.dart';
import 'package:finpay/view/profile/widget/custom_row.dart';
import 'package:finpay/view/profile/widget/notification_view.dart';
import 'package:finpay/view/profile/widget/social_view.dart';
import 'package:finpay/view/splash/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finpay/view/profile/chat_screen.dart';
import 'package:finpay/view/profile/currency_settings_screen.dart';
import 'package:finpay/view/profile/language_settings_screen.dart';
import 'package:finpay/view/profile/privacy_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final profileController = Get.put(ProfileController());
  @override
  void initState() {
    setState(() {
      if (AppTheme.isLightTheme == false) {
        profileController.darkMode.value = true;
      } else {
        profileController.darkMode.value = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int light = 1;
    int dark = 2;
    changeColor(int color) {
      if (color == light) {
        MyApp.setCustomeTheme(context, 6);
      } else {
        MyApp.setCustomeTheme(context, 7);
      }
    }

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
          "settings".tr,
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
                "settings".tr,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 32),
              Text(
                'general'.tr,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffA2A0A8),
                    ),
              ),
              const SizedBox(height: 16),
              notificationView(
                context,
                'dark_mode'.tr,
                CupertinoSwitch(
                  value: profileController.darkMode.value,
                  activeColor: HexColor(AppTheme.primaryColorString!),
                  onChanged: (v) {
                    setState(() {
                      profileController.darkMode.value = v;
                      if (v == true) {
                        changeColor(dark);
                      } else {
                        changeColor(light);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 22),
              customRow(
                context,
                'reset_password'.tr,
              ),
              const SizedBox(height: 32),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.isLightTheme == false
                        ? const Color(0xff323045)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "notifications".tr,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CurrencySettingsScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.isLightTheme == false
                        ? const Color(0xff323045)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: HexColor(AppTheme.primaryColorString!)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.currency_exchange,
                          color: HexColor(AppTheme.primaryColorString!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "currency_settings".tr,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LanguageSettingsScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.isLightTheme == false
                        ? const Color(0xff323045)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: HexColor(AppTheme.primaryColorString!)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.language,
                          color: HexColor(AppTheme.primaryColorString!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "language_settings".tr,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.isLightTheme == false
                        ? const Color(0xff323045)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "privacy".tr,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.isLightTheme == false
                        ? const Color(0xff323045)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_outlined,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "chat_assistant".tr,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.isLightTheme == false
                        ? const Color(0xff323045)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.dark_mode_outlined,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "dark_mode".tr,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Switch(
                        value: AppTheme.isLightTheme == false,
                        onChanged: (value) {
                          Get.changeThemeMode(
                            Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text("log_out".tr),
                      content: Text("log_out_confirmation".tr),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("cancel".tr),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            Get.offAllNamed('/login');
                          },
                          child: Text("log_out".tr),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.isLightTheme == false
                        ? const Color(0xff323045)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "log_out".tr,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'follow_us'.tr,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffA2A0A8),
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  socialView(
                    AppTheme.isLightTheme == false
                        ? DefaultImages.twitterdark
                        : DefaultImages.twitter,
                  ),
                  socialView(
                    AppTheme.isLightTheme == false
                        ? DefaultImages.facebookDark
                        : DefaultImages.facebook,
                  ),
                  socialView(
                    AppTheme.isLightTheme == false
                        ? DefaultImages.tiktokDark
                        : DefaultImages.tikTok,
                  ),
                  socialView(
                    AppTheme.isLightTheme == false
                        ? DefaultImages.instagramDark
                        : DefaultImages.instagram,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'version'.tr,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff9EA3AE),
                      ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
