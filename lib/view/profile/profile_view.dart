// ignore_for_file: deprecated_member_use

import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/currency_controller.dart';
import 'package:finpay/controller/profile_controller.dart';
import 'package:finpay/view/profile/chat_screen.dart';
import 'package:finpay/view/profile/edit_profile_screen.dart';
import 'package:finpay/view/profile/setting_screen.dart';
import 'package:finpay/view/profile/widget/income_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final profileController = Get.put(ProfileController());
  final currencyController = Get.put(CurrencyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.isLightTheme == false
          ? HexColor('#15141f')
          : Theme.of(context).appBarTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "my_account".tr,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingScreen(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.settings_outlined,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
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
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: HexColor(AppTheme.primaryColorString!),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              "D",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daniel",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              "daniel@example.com",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 14,
                                    color: const Color(0xffA2A0A8),
                                  ),
                            ),
                          ],
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
                  "overview".tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.isLightTheme == false
                              ? const Color(0xff323045)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "net_income".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 14,
                                    color: const Color(0xffA2A0A8),
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Obx(() => Text(
                                  currencyController.formatAmount(5000),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                      ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.isLightTheme == false
                              ? const Color(0xff323045)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "expenses".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 14,
                                    color: const Color(0xffA2A0A8),
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Obx(() => Text(
                                  currencyController.formatAmount(2000),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                      ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  "weekly_spending".tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.isLightTheme == false
                        ? const Color(0xff323045)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "left_to_spend".tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  color: const Color(0xffA2A0A8),
                                ),
                          ),
                          Obx(() => Text(
                                currencyController.formatAmount(3000),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                              )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: 0.7,
                        backgroundColor: const Color(0xffE5E5E5),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          HexColor(AppTheme.primaryColorString!),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: HexColor(AppTheme.primaryColorString!),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.star,
                            color: HexColor(AppTheme.primaryColorString!),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "member_gold".tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            "get_more_benefits".tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
