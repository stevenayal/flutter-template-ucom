import 'package:finpay/model/sitema_reservas.dart';
import 'package:get/get.dart';
import 'package:finpay/api/local.db.service.dart';
import 'package:flutter/material.dart';

class ReservaController extends GetxController {
  RxList<Piso> pisos = <Piso>[].obs;
  Rx<Piso?> pisoSeleccionado = Rx<Piso?>(null);
  RxList<Lugar> lugaresDisponibles = <Lugar>[].obs;
  Rx<Lugar?> lugarSeleccionado = Rx<Lugar?>(null);
  Rx<DateTime?> horarioInicio = Rx<DateTime?>(null);
  Rx<DateTime?> horarioSalida = Rx<DateTime?>(null);
  RxInt duracionSeleccionada = 0.obs;
  final db = LocalDBService();
  RxList<Auto> autosCliente = <Auto>[].obs;
  Rx<Auto?> autoSeleccionado = Rx<Auto?>(null);
  String codigoClienteActual =
      'cliente_1'; // ← este puede venir de login o contexto
  @override
  void onInit() {
    super.onInit();
    resetearCampos();
    cargarAutosDelCliente();
    cargarPisosYLugares();
  }

  Future<void> cargarPisosYLugares() async {
    final rawPisos = await db.getAll("pisos.json");
    final rawLugares = await db.getAll("lugares.json");
    final rawReservas = await db.getAll("reservas.json");

    final reservas = rawReservas.map((e) => Reserva.fromJson(e)).toList();
    final todosLugares = rawLugares.map((e) => Lugar.fromJson(e)).toList();

    // Unir pisos con sus lugares correspondientes
    pisos.value = rawPisos.map((pJson) {
      final codigoPiso = pJson['codigo'];
      final lugaresDelPiso =
          todosLugares.where((l) => l.codigoPiso == codigoPiso).toList();

      return Piso(
        codigo: codigoPiso,
        descripcion: pJson['descripcion'],
        lugares: lugaresDelPiso,
      );
    }).toList();

    // Filtrar lugares disponibles según horario seleccionado
    DateTime? inicio = horarioInicio.value;
    DateTime? fin = horarioSalida.value;
    
    lugaresDisponibles.value = todosLugares.where((lugar) {
      // Buscar reservas activas para este lugar
      final reservasLugar = reservas.where((r) =>
        r.codigoLugar == lugar.codigoLugar &&
        (r.estadoReserva == 'PENDIENTE' || r.estadoReserva == 'COMPLETADO')
      );
      if (inicio == null || fin == null) {
        // Si no hay horario seleccionado, solo filtrar por estado DISPONIBLE
        return lugar.estado == 'DISPONIBLE';
      }
      // Si hay horario seleccionado, filtrar por solapamiento
      for (final r in reservasLugar) {
        if (_horariosSeSolapan(inicio, fin, r.horarioInicio, r.horarioSalida)) {
          return false;
        }
      }
      return lugar.estado == 'DISPONIBLE';
    }).toList();
  }

  bool _horariosSeSolapan(DateTime inicio1, DateTime fin1, DateTime inicio2, DateTime fin2) {
    return inicio1.isBefore(fin2) && fin1.isAfter(inicio2);
  }

  Future<void> seleccionarPiso(Piso piso) {
    pisoSeleccionado.value = piso;
    lugarSeleccionado.value = null;

    // filtrar lugares de este piso
    lugaresDisponibles.refresh();
    return Future.value();
  }

  Future<bool> confirmarReserva() async {
    if (pisoSeleccionado.value == null ||
        lugarSeleccionado.value == null ||
        horarioInicio.value == null ||
        horarioSalida.value == null) {
      return false;
    }

    final duracionEnHoras =
        horarioSalida.value!.difference(horarioInicio.value!).inMinutes / 60;

    if (duracionEnHoras <= 0) return false;

    final montoCalculado = (duracionEnHoras * 10000).roundToDouble();

    if (autoSeleccionado.value == null) return false;

    // Validar que no exista una reserva solapada para este lugar
    final rawReservas = await db.getAll("reservas.json");
    final reservas = rawReservas.map((e) => Reserva.fromJson(e)).toList();
    final reservasSolapadas = reservas.where((r) =>
      r.codigoLugar == lugarSeleccionado.value!.codigoLugar &&
      (r.estadoReserva == 'PENDIENTE' || r.estadoReserva == 'COMPLETADO') &&
      _horariosSeSolapan(horarioInicio.value!, horarioSalida.value!, r.horarioInicio, r.horarioSalida)
    );
    if (reservasSolapadas.isNotEmpty) {
      // Ya existe una reserva para este lugar y horario
      Get.snackbar(
        'Lugar no disponible',
        'Ya existe una reserva para este lugar y horario.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.context != null ? Theme.of(Get.context!).colorScheme.error : null,
        colorText: Get.context != null ? Theme.of(Get.context!).colorScheme.onError : null,
      );
      return false;
    }

    final nuevaReserva = Reserva(
      codigoReserva: "RES-${DateTime.now().millisecondsSinceEpoch}",
      horarioInicio: horarioInicio.value!,
      horarioSalida: horarioSalida.value!,
      monto: montoCalculado,
      estadoReserva: "PENDIENTE",
      chapaAuto: autoSeleccionado.value!.chapa,
      clienteId: codigoClienteActual,
      codigoLugar: lugarSeleccionado.value!.codigoLugar,
    );

    try {
      // Guardar la reserva
      final reservas = await db.getAll("reservas.json");
      reservas.add(nuevaReserva.toJson());
      await db.saveAll("reservas.json", reservas);

      // Marcar el lugar como reservado
      final lugares = await db.getAll("lugares.json");
      final index = lugares.indexWhere(
        (l) => l['codigoLugar'] == lugarSeleccionado.value!.codigoLugar,
      );
      if (index != -1) {
        lugares[index]['estado'] = "RESERVADO";
        await db.saveAll("lugares.json", lugares);
      }

      return true;
    } catch (e) {
      print("Error al guardar reserva: $e");
      return false;
    }
  }

  void resetearCampos() {
    pisoSeleccionado.value = null;
    lugarSeleccionado.value = null;
    horarioInicio.value = null;
    horarioSalida.value = null;
    duracionSeleccionada.value = 0;
  }

  Future<void> cargarAutosDelCliente() async {
    final rawAutos = await db.getAll("autos.json");
    final autos = rawAutos.map((e) => Auto.fromJson(e)).toList();

    autosCliente.value =
        autos.where((a) => a.clienteId == codigoClienteActual).toList();
  }

  @override
  void onClose() {
    resetearCampos();
    super.onClose();
  }
}
