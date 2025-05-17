// ignore_for_file: deprecated_member_use

import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/currency_controller.dart';
import 'package:finpay/controller/home_controller.dart';
import 'package:finpay/view/home/widget/transaction_list.dart';
import 'package:finpay/view/statistics/widget/card_view.dart';
import 'package:finpay/view/statistics/widget/circle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  final homeController = Get.put(HomeController());
  final currencyController = Get.put(CurrencyController());
  
  @override
  void initState() {
    homeController.customInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: AppTheme.isLightTheme == false
          ? HexColor('#15141f')
          : HexColor(AppTheme.primaryColorString!).withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).textTheme.titleLarge!.color,
                    ),
                  ),
                  Text(
                    "statistics".tr,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const Icon(
                    Icons.arrow_back,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            homeController.isWeek.value == true
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "spending".tr,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color!
                                        .withOpacity(0.60),
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Obx(() => Text(
                                  currencyController.formatAmount(1691.54),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                      ),
                                )),
                            const SizedBox(width: 10),
                            Text(
                              "from_last_month".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color!
                                        .withOpacity(0.60),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cardView(
                    context,
                    homeController.isWeek.value == true
                        ? HexColor(AppTheme.primaryColorString!)
                        : AppTheme.isLightTheme == false
                            ? const Color(0xff211F32)
                            : const Color(0xffF9F9FA),
                    homeController.isWeek.value == true
                        ? Colors.white
                        : const Color(0xffA2A0A8),
                    () {
                      setState(() {
                        homeController.isWeek.value = true;
                        homeController.isMonth.value = false;
                        homeController.isYear.value = false;
                      });
                    },
                    "week".tr,
                  ),
                  cardView(
                    context,
                    homeController.isMonth.value == true
                        ? HexColor('#6C56F9')
                        : AppTheme.isLightTheme == false
                            ? const Color(0xff211F32)
                            : const Color(0xffF9F9FA),
                    homeController.isMonth.value == true
                        ? Colors.white
                        : const Color(0xffA2A0A8),
                    () {
                      setState(() {
                        homeController.isWeek.value = false;
                        homeController.isMonth.value = true;
                        homeController.isYear.value = false;
                      });
                    },
                    "month".tr,
                  ),
                  cardView(
                    context,
                    homeController.isYear.value == true
                        ? HexColor(AppTheme.primaryColorString!)
                        : AppTheme.isLightTheme == false
                            ? const Color(0xff211F32)
                            : const Color(0xffF9F9FA),
                    homeController.isYear.value == true
                        ? Colors.white
                        : const Color(0xffA2A0A8),
                    () {
                      setState(() {
                        homeController.isWeek.value = false;
                        homeController.isMonth.value = false;
                        homeController.isYear.value = true;
                      });
                    },
                    "year".tr,
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  const SizedBox(height: 20),
                  homeController.isWeek.value == true
                      ? Column(
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: SvgPicture.asset(
                                AppTheme.isLightTheme == false
                                    ? DefaultImages.darkChart2
                                    : DefaultImages.chart2,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 60,
                              width: Get.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: ListView(
                                  physics: const ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: circleCard(
                                            context,
                                            "food".tr,
                                            HexColor(
                                                AppTheme.primaryColorString!),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: circleCard(
                                            context,
                                            "bills".tr,
                                            HexColor('#907FFA'),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: circleCard(
                                            context,
                                            "gadget".tr,
                                            HexColor('#CCCACF'),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: circleCard(
                                            context,
                                            "food".tr,
                                            HexColor(
                                                AppTheme.primaryColorString!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SizedBox(
                            height: 250,
                            child: SvgPicture.asset(
                              AppTheme.isLightTheme == false
                                  ? DefaultImages.darkChart1
                                  : DefaultImages.chart1,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.isLightTheme == false
                            ? const Color(0xff211F32)
                            : const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff000000).withOpacity(0.10),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  homeController.isWeek.value == true
                                      ? "this_week".tr
                                      : homeController.isMonth.value == true
                                          ? "this_month".tr
                                          : "this_year".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                Text(
                                  "view_all".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: HexColor(
                                              AppTheme.primaryColorString!)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              for (var i = 0;
                                  i < homeController.transactionList.length;
                                  i++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: transactionList(
                                    homeController.transactionList[i].image,
                                    homeController
                                        .transactionList[i].background,
                                    homeController.transactionList[i].title,
                                    homeController.transactionList[i].subTitle,
                                    homeController.transactionList[i].price,
                                    homeController.transactionList[i].time,
                                  ),
                                )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
