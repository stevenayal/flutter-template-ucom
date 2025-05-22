class Auto {
  final String chapa;
  final String marca;
  final String modelo;
  final String chasis;
  final String clienteId;

  Auto({
    required this.chapa,
    required this.marca,
    required this.modelo,
    required this.chasis,
    required this.clienteId,
  });

  factory Auto.fromJson(Map<String, dynamic> json) {
    return Auto(
      chapa: json['chapa'],
      marca: json['marca'],
      modelo: json['modelo'],
      chasis: json['chasis'],
      clienteId: json['clienteId'],
    );
  }
}

class Piso {
  final String codigo;
  final String descripcion;
  final List<Lugar> lugares;

  Piso({
    required this.codigo,
    required this.descripcion,
    required this.lugares,
  });

  factory Piso.fromJson(Map<String, dynamic> json) {
    return Piso(
      codigo: json['codigo'],
      descripcion: json['descripcion'],
      lugares: (json['lugares'] as List)
          .map((l) => Lugar.fromJson(l))
          .toList(),
    );
  }
}

class Lugar {
  final String codigoLugar;
  final String codigoPiso;
  final String estado;
  final String descripcionLugar;

  Lugar({
    required this.codigoLugar,
    required this.codigoPiso,
    required this.estado,
    required this.descripcionLugar,
  });

  factory Lugar.fromJson(Map<String, dynamic> json) {
    return Lugar(
      codigoLugar: json['codigoLugar'],
      codigoPiso: json['codigoPiso'],
      estado: json['estado'],
      descripcionLugar: json['descripcionLugar'],
    );
  }
}

class Reserva {
  final String codigoReserva;
  final DateTime horarioInicio;
  final DateTime horarioSalida;
  final double monto;
  final String estadoReserva;
  final String chapaAuto;

  Reserva({
    required this.codigoReserva,
    required this.horarioInicio,
    required this.horarioSalida,
    required this.monto,
    required this.estadoReserva,
    required this.chapaAuto,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      codigoReserva: json['codigoReserva'],
      horarioInicio: DateTime.parse(json['horarioInicio']),
      horarioSalida: DateTime.parse(json['horarioSalida']),
      monto: json['monto'].toDouble(),
      estadoReserva: json['estadoReserva'],
      chapaAuto: json['chapaAuto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigoReserva': codigoReserva,
      'horarioInicio': horarioInicio.toIso8601String(),
      'horarioSalida': horarioSalida.toIso8601String(),
      'monto': monto,
      'estadoReserva': estadoReserva,
      'chapaAuto': chapaAuto,
    };
  }
} 