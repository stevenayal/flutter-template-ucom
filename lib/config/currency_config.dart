import 'package:intl/intl.dart';

enum Currency {
  usd,
  pyg,
}

class CurrencyConfig {
  static final Map<Currency, CurrencyInfo> currencies = {
    Currency.usd: CurrencyInfo(
      code: 'USD',
      symbol: '\$',
      name: 'US Dollar',
      locale: 'en_US',
      decimalDigits: 2,
    ),
    Currency.pyg: CurrencyInfo(
      code: 'PYG',
      symbol: '₲',
      name: 'Paraguayan Guaraní',
      locale: 'es_PY',
      decimalDigits: 0,
    ),
  };

  static Currency currentCurrency = Currency.usd;

  static String formatAmount(double amount) {
    final currencyInfo = currencies[currentCurrency]!;
    final formatter = NumberFormat.currency(
      locale: currencyInfo.locale,
      symbol: currencyInfo.symbol,
      decimalDigits: currencyInfo.decimalDigits,
    );
    return formatter.format(amount);
  }

  static String formatAmountWithCurrency(double amount, Currency currency) {
    final currencyInfo = currencies[currency]!;
    final formatter = NumberFormat.currency(
      locale: currencyInfo.locale,
      symbol: currencyInfo.symbol,
      decimalDigits: currencyInfo.decimalDigits,
    );
    return formatter.format(amount);
  }
}

class CurrencyInfo {
  final String code;
  final String symbol;
  final String name;
  final String locale;
  final int decimalDigits;

  CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.name,
    required this.locale,
    required this.decimalDigits,
  });
} 