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
    // Asegurarse de que el monto sea un número entero
    final montoEntero = monto.round();
    
    // Crear el formateador con configuración específica para guaraníes
    // Usamos 'PYG' en lugar del símbolo ₲ para asegurar la compatibilidad de fuentes.
    final formatter = NumberFormat.currency(
      locale: 'es_PY',
      symbol: 'PYG ', // Cambiado a 'PYG '
      decimalDigits: 0,
      customPattern: '###,##0 ¤', // Patrón ajustado para 'PYG ' al final o al inicio
    );
    
    // Formatear el monto
    String montoFormateado = formatter.format(montoEntero).trim();
    
    // El patrón '###,##0 ¤' coloca el símbolo al final por defecto.
    // Si queremos 'PYG ' al inicio, podemos ajustar esto:
    if (montoFormateado.endsWith('PYG')) {
       montoFormateado = 'PYG ' + montoFormateado.replaceAll('PYG', '').trim();
    } else if (montoFormateado.startsWith('PYG')) {
       // Ya está al inicio, solo asegurar espacio
       montoFormateado = 'PYG ' + montoFormateado.replaceAll('PYG', '').trim();
    }
    
    // Eliminar posible doble espacio si se añade 'PYG ' manualmente
    montoFormateado = montoFormateado.replaceAll('  ', ' ');

    return montoFormateado.trim();
  }
} 