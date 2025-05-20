import 'package:finpay/config/currency_config.dart';
import 'package:get/get.dart';

class CurrencyController extends GetxController {
  final selectedCurrency = Currency.usd.obs;

  void changeCurrency(Currency currency) {
    selectedCurrency.value = currency;
  }

  String formatAmount(double amount) {
    return CurrencyConfig.formatAmount(amount, selectedCurrency.value);
  }
} 