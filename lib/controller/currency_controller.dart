import 'package:finpay/config/currency_config.dart';
import 'package:get/get.dart';

class CurrencyController extends GetxController {
  final Rx<Currency> selectedCurrency = Currency.usd.obs;

  @override
  void onInit() {
    super.onInit();
    selectedCurrency.value = CurrencyConfig.currentCurrency;
  }

  void changeCurrency(Currency currency) {
    selectedCurrency.value = currency;
    CurrencyConfig.currentCurrency = currency;
  }

  String formatAmount(double amount) {
    return CurrencyConfig.formatAmount(amount);
  }

  String formatAmountWithCurrency(double amount, Currency currency) {
    return CurrencyConfig.formatAmountWithCurrency(amount, currency);
  }
} 