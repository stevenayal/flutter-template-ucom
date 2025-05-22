import 'package:intl/intl.dart';

class UtilesApp {
  static String formatearFechaDdMMAaaa(DateTime fecha) {
    return DateFormat('dd/MM/yyyy').format(fecha);
  }

  static String formatearGuaranies(double monto) {
    final formatter = NumberFormat('#,##0', 'es_PY');
    return formatter.format(monto).replaceAll(',', '.');
  }

  static String formatearGuaraniesConSimbolo(double monto) {
    final formatter = NumberFormat.currency(
      locale: 'es_PY',
      symbol: '₲',
      decimalDigits: 0,
    );
    return formatter.format(monto);
  }
} 