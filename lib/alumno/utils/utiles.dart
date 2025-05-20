import 'package:intl/intl.dart';

class UtilesApp {
  static String formatearFechaDdMMAaaa(DateTime fecha) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(fecha);
  }

  static String formatearGuaranies(double monto) {
    final formatter = NumberFormat('#,##0', 'es_PY');
    return formatter.format(monto).replaceAll(',', '.');
  }

    static String formatearGuaraniesConSimbolo(double monto) {
    final formatter = NumberFormat('Gs #,##0', 'es_PY');
    return formatter.format(monto).replaceAll(',', '.');
  }

} 