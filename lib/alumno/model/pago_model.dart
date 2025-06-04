class PagoDetallado {
  final String codigoPago;
  final String codigoReservaAsociada;
  final double montoPagado;
  final DateTime fechaPago;
  final String metodoPago; // EFECTIVO, TARJETA, TRANSFERENCIA
  final String estadoPago; // PENDIENTE, COMPLETADO, CANCELADO
  final String? comprobanteUrl; // URL opcional para comprobante
  final String? notas; // Notas adicionales sobre el pago

  PagoDetallado({
    required this.codigoPago,
    required this.codigoReservaAsociada,
    required this.montoPagado,
    required this.fechaPago,
    required this.metodoPago,
    required this.estadoPago,
    this.comprobanteUrl,
    this.notas,
  });

  factory PagoDetallado.fromJson(Map<String, dynamic> json) {
    return PagoDetallado(
      codigoPago: json['codigoPago'],
      codigoReservaAsociada: json['codigoReservaAsociada'],
      montoPagado: json['montoPagado'].toDouble(),
      fechaPago: DateTime.parse(json['fechaPago']),
      metodoPago: json['metodoPago'],
      estadoPago: json['estadoPago'],
      comprobanteUrl: json['comprobanteUrl'],
      notas: json['notas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigoPago': codigoPago,
      'codigoReservaAsociada': codigoReservaAsociada,
      'montoPagado': montoPagado,
      'fechaPago': fechaPago.toIso8601String(),
      'metodoPago': metodoPago,
      'estadoPago': estadoPago,
      'comprobanteUrl': comprobanteUrl,
      'notas': notas,
    };
  }
} 