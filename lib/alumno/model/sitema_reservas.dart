// Archivo del alumno
// Este archivo es parte del trabajo realizado por el alumno y puede contener modificaciones.

// TODO: Add original content for sitema_reservas.dart if available
// Basic placeholder classes based on usage in ReservaController

class Cliente {
  String id;
  String nombre;
  String apellido;
  String telefono;
  List<Auto> autos;

  Cliente({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.autos,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json['id'],
        nombre: json['nombre'],
        apellido: json['apellido'],
        telefono: json['telefono'],
        autos: List.empty(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'autos': autos.map((a) => a.toJson()).toList(),
      };
}

class Auto {
  String chapa;
  String marca;
  String modelo;
  String chasis;
  String clienteId;

  Auto(
      {required this.chapa,
      required this.marca,
      required this.modelo,
      required this.chasis,
      required this.clienteId});

  factory Auto.fromJson(Map<String, dynamic> json) => Auto(
        chapa: json['chapa'],
        marca: json['marca'],
        modelo: json['modelo'],
        chasis: json['chasis'],
        clienteId: json['clienteId'],
      );

  Map<String, dynamic> toJson() => {
        'chapa': chapa,
        'marca': marca,
        'modelo': modelo,
        'chasis': chasis,
        'clienteId': clienteId
      };
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

  factory Piso.fromJson(Map<String, dynamic> json) => Piso(
        codigo: json['codigo'],
        descripcion: json['descripcion'],
        lugares:
            (json['lugares'] as List).map((l) => Lugar.fromJson(l)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'descripcion': descripcion,
        'lugares': lugares.map((l) => l.toJson()).toList(),
      };
}

class Lugar {
  final String codigoLugar;
  final String codigoPiso;
  final String estado; // e.g., DISPONIBLE, RESERVADO

  Lugar({
    required this.codigoLugar,
    required this.codigoPiso,
    required this.estado,
  });

  factory Lugar.fromJson(Map<String, dynamic> json) {
    return Lugar(
      codigoLugar: json['codigoLugar'],
      codigoPiso: json['codigoPiso'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() => {
        'codigoPiso': codigoPiso,
        'codigoLugar': codigoLugar,
        'estado': estado,
      };
}

class Reserva {
  final String codigoReserva;
  final DateTime horarioInicio;
  final DateTime horarioSalida;
  final double monto;
  final String estadoReserva; // e.g., PENDIENTE, CONFIRMADA, CANCELADA
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
      horarioInicio: DateTime.parse(json['horarioInicio']), // Assuming ISO 8601 string
      horarioSalida: DateTime.parse(json['horarioSalida']), // Assuming ISO 8601 string
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

class Pago {
  String codigoPago;
  String codigoReservaAsociada;
  double montoPagado;
  DateTime fechaPago;

  Pago({
    required this.codigoPago,
    required this.codigoReservaAsociada,
    required this.montoPagado,
    required this.fechaPago,
  });

  factory Pago.fromJson(Map<String, dynamic> json) => Pago(
        codigoPago: json['codigoPago'],
        codigoReservaAsociada: json['codigoReservaAsociada'],
        montoPagado: json['montoPagado'].toDouble(),
        fechaPago: DateTime.parse(json['fechaPago']),
      );

  Map<String, dynamic> toJson() => {
        'codigoPago': codigoPago,
        'codigoReservaAsociada': codigoReservaAsociada,
        'montoPagado': montoPagado,
        'fechaPago': fechaPago.toIso8601String(),
      };
} 