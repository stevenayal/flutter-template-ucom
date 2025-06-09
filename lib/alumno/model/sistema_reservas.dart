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
  }) {
    print("DEBUG (Piso constructor): Se creó un Piso con código: $codigo, descripción: $descripcion, lugares: ${lugares.map((l) => l.codigoLugar).join(', ')}");
  }

  factory Piso.fromJson(Map<String, dynamic> json) {
    final codigo = json['codigo'];
    final descripcion = json['descripcion'];
    final lugares = (json['lugares'] as List).map((l) => Lugar.fromJson(l)).toList();
    print("DEBUG (Piso.fromJson): Se creó un Piso (fromJson) con código: $codigo, descripción: $descripcion, lugares: ${lugares.map((l) => l.codigoLugar).join(', ')}");
    return Piso(codigo: codigo, descripcion: descripcion, lugares: lugares);
  }

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'descripcion': descripcion,
        'lugares': lugares.map((l) => l.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Piso &&
          runtimeType == other.runtimeType &&
          codigo == other.codigo &&
          descripcion == other.descripcion;

  @override
  int get hashCode => codigo.hashCode ^ descripcion.hashCode;
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

  Map<String, dynamic> toJson() {
    return {
      'codigoLugar': codigoLugar,
      'codigoPiso': codigoPiso,
      'estado': estado,
      'descripcionLugar': descripcionLugar,
    };
  }
}

class Reserva {
  final String codigoReserva;
  final DateTime horarioInicio;
  final DateTime horarioSalida;
  final double monto;
  final String estadoReserva;
  final String chapaAuto;
  final String clienteId;
  final String codigoLugar;

  Reserva({
    required this.codigoReserva,
    required this.horarioInicio,
    required this.horarioSalida,
    required this.monto,
    required this.estadoReserva,
    required this.chapaAuto,
    required this.clienteId,
    required this.codigoLugar,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      codigoReserva: json['codigoReserva'],
      horarioInicio: DateTime.parse(json['horarioInicio']),
      horarioSalida: DateTime.parse(json['horarioSalida']),
      monto: json['monto'].toDouble(),
      estadoReserva: json['estadoReserva'],
      chapaAuto: json['chapaAuto'],
      clienteId: json['clienteId'],
      codigoLugar: json['codigoLugar'],
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
      'clienteId': clienteId,
      'codigoLugar': codigoLugar,
    };
  }
} 