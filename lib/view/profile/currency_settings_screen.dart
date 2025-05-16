import 'package:finpay/config/currency_config.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/currency_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrencySettingsScreen extends StatelessWidget {
  const CurrencySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyController = Get.put(CurrencyController());

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
          "currency_settings".tr,
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
                "select_currency".tr,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 32),
              Obx(() => Column(
                    children: Currency.values.map((currency) {
                      final currencyInfo = CurrencyConfig.currencies[currency]!;
                      return InkWell(
                        onTap: () {
                          currencyController.changeCurrency(currency);
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
                              color: currencyController.selectedCurrency.value ==
                                      currency
                                  ? HexColor(AppTheme.primaryColorString!)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                currencyInfo.symbol,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currencyInfo.code,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    currency.name.tr,
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
                              if (currencyController.selectedCurrency.value ==
                                  currency)
                                Icon(
                                  Icons.check_circle,
                                  color: HexColor(AppTheme.primaryColorString!),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
} 