enum Currency {
  usd,
  pyg,
}

class CurrencyConfig {
  static String getSymbol(Currency currency) {
    switch (currency) {
      case Currency.usd:
        return '\$';
      case Currency.pyg:
        return '₲';
    }
  }

  static String formatAmount(double amount, Currency currency) {
    final symbol = getSymbol(currency);
    return '$symbol${amount.toStringAsFixed(2)}';
  }
} 