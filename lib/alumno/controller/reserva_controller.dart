// Archivo del alumno
// Este archivo es parte del trabajo realizado por el alumno y puede contener modificaciones.

import 'package:get/get.dart';
import '../model/sistema_reservas.dart';
import '../../api/local.db.service.dart';
import 'package:flutter/material.dart';

class AlumnoReservaController extends GetxController {
  final autoSeleccionado = Rxn<Auto>();
  final pisoSeleccionado = Rxn<Piso>();
  final lugarSeleccionado = Rxn<Lugar>();
  final horarioInicio = Rxn<DateTime>();
  final horarioSalida = Rxn<DateTime>();
  final duracionSeleccionada = 0.obs;
  final isLoading = false.obs;

  // Datos de ejemplo
  final autosCliente = <Auto>[].obs;
  final pisos = <Piso>[].obs;
  final lugaresDisponibles = <Lugar>[].obs;

  final db = LocalDBService();
  String codigoClienteActual = 'cliente_1';

  @override
  void onInit() {
    super.onInit();
    resetearCampos();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await cargarAutosDelCliente();
    await cargarPisosYLugares();
  }

  Future<void> cargarAutosDelCliente() async {
    final rawAutos = await db.getAll("autos.json");
    final autos = rawAutos.map((e) => Auto.fromJson(e)).toList();
    autosCliente.value = autos.where((a) => a.clienteId == codigoClienteActual).toList();
  }

  Future<void> cargarPisosYLugares() async {
    final rawPisos = await db.getAll("pisos.json");
    print("DEBUG (cargarPisosYLugares): rawPisos (JSON) = $rawPisos");
    final rawLugares = await db.getAll("lugares.json");
    print("DEBUG (cargarPisosYLugares): rawLugares (JSON) = $rawLugares");
    final rawReservas = await db.getAll("reservas.json");
    print("DEBUG (cargarPisosYLugares): rawReservas (JSON) = $rawReservas");

    final reservas = rawReservas.map((e) => Reserva.fromJson(e)).toList();
    print("DEBUG (cargarPisosYLugares): reservas (mapeadas) = ${reservas.map((r) => '${r.codigoReserva} (${r.codigoLugar}, ${r.horarioInicio} a ${r.horarioSalida}, estado: ${r.estadoReserva})').join(', ')}");
    final todosLugares = rawLugares.map((e) => Lugar.fromJson(e)).toList();
    print("DEBUG (cargarPisosYLugares): todosLugares (mapeados) = ${todosLugares.map((l) => '${l.codigoLugar} (piso: ${l.codigoPiso}, estado: ${l.estado})').join(', ')}");

    pisos.value = rawPisos.map((pJson) {
      final codigoPiso = pJson['codigo'];
      final lugaresDelPiso = todosLugares.where((l) => l.codigoPiso == codigoPiso).toList();
      print("DEBUG (cargarPisosYLugares): para piso $codigoPiso se filtraron ${lugaresDelPiso.length} lugares (códigos: ${lugaresDelPiso.map((l) => l.codigoLugar).join(', ')})");
      return Piso(
        codigo: codigoPiso,
        descripcion: pJson['descripcion'],
        lugares: lugaresDelPiso,
      );
    }).toList();

    // Debug: imprimir el contenido de pisos y el valor de pisoSeleccionado
    print("DEBUG (cargarPisosYLugares): pisos cargados: ${pisos.map((p) => p.codigo).join(', ')}");
    print("DEBUG (cargarPisosYLugares): pisoSeleccionado (antes) = ${pisoSeleccionado.value?.codigo}");

    DateTime? inicio = horarioInicio.value;
    DateTime? fin = horarioSalida.value;
    print("DEBUG (cargarPisosYLugares): horarioInicio (inicio) = $inicio, horarioSalida (fin) = $fin");
    lugaresDisponibles.value = todosLugares.where((lugar) {
      final reservasLugar = reservas.where((r) =>
        r.codigoLugar == lugar.codigoLugar &&
        (r.estadoReserva == 'PENDIENTE' || r.estadoReserva == 'COMPLETADO')
      );
      print("DEBUG (cargarPisosYLugares): reservasLugar para lugar ${lugar.codigoLugar} (filtradas) = ${reservasLugar.map((r) => '${r.codigoReserva} (${r.horarioInicio} a ${r.horarioSalida}, estado: ${r.estadoReserva})').join(', ')}");
      if (inicio == null || fin == null) {
        return lugar.estado == 'DISPONIBLE';
      }
      for (final r in reservasLugar) {
        if (_horariosSeSolapan(inicio, fin, r.horarioInicio, r.horarioSalida)) {
          return false;
        }
      }
      return lugar.estado == 'DISPONIBLE';
    }).toList();
    print("DEBUG (cargarPisosYLugares): lugaresDisponibles (filtrados) = "+lugaresDisponibles.map((l) => l.codigoLugar).join(', '));

    // Autoselección de piso fuera del build
    if (pisos.isNotEmpty && (pisoSeleccionado.value == null ||
        !pisos.any((p) => p.codigo == pisoSeleccionado.value?.codigo))) {
      pisoSeleccionado.value = pisos.first;
    }
  }

  bool _horariosSeSolapan(DateTime inicio1, DateTime fin1, DateTime inicio2, DateTime fin2) {
    return inicio1.isBefore(fin2) && fin1.isAfter(inicio2);
  }

  void seleccionarPiso(Piso piso) {
    print("DEBUG (seleccionarPiso): recibido piso con código: ${piso.codigo}");
    final pisoEnLista = pisos.firstWhereOrNull((p) => p.codigo == piso.codigo);
    print("DEBUG (seleccionarPiso): pisoEnLista (encontrado) = ${pisoEnLista?.codigo}");
    pisoSeleccionado.value = pisoEnLista;
    lugarSeleccionado.value = null;
  }

  Future<bool> confirmarReserva() async {
    print('DEBUG(confirmarReserva): INICIO');
    if (lugarSeleccionado.value == null ||
        horarioInicio.value == null ||
        horarioSalida.value == null ||
        autoSeleccionado.value == null) {
      print('DEBUG(confirmarReserva): Faltan datos para reservar');
      return false;
    }

    isLoading.value = true;

    // Validar que no exista una reserva solapada para este lugar
    final rawReservas = await db.getAll("reservas.json");
    print('DEBUG(confirmarReserva): reservas actuales = '+rawReservas.toString());
    final reservas = rawReservas.map((e) => Reserva.fromJson(e)).toList();
    final reservasSolapadas = reservas.where((r) =>
      r.codigoLugar == lugarSeleccionado.value!.codigoLugar &&
      (r.estadoReserva == 'PENDIENTE' || r.estadoReserva == 'COMPLETADO') &&
      _horariosSeSolapan(horarioInicio.value!, horarioSalida.value!, r.horarioInicio, r.horarioSalida)
    );
    print('DEBUG(confirmarReserva): reservasSolapadas = '+reservasSolapadas.toString());
    if (reservasSolapadas.isNotEmpty) {
      print('DEBUG(confirmarReserva): Ya existe una reserva solapada');
      Get.snackbar(
        'Lugar no disponible',
        'Ya existe una reserva para este lugar y horario.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.context != null ? Theme.of(Get.context!).colorScheme.error : null,
        colorText: Get.context != null ? Theme.of(Get.context!).colorScheme.onError : null,
      );
      isLoading.value = false;
      return false;
    }

    // Crear la nueva reserva
    final nuevaReserva = Reserva(
      codigoReserva: "RES-${DateTime.now().millisecondsSinceEpoch}",
      horarioInicio: horarioInicio.value!,
      horarioSalida: horarioSalida.value!,
      monto: ((horarioSalida.value!.difference(horarioInicio.value!).inMinutes / 60) * 10000).roundToDouble(),
      estadoReserva: "PENDIENTE",
      chapaAuto: autoSeleccionado.value!.chapa,
      clienteId: codigoClienteActual,
      codigoLugar: lugarSeleccionado.value!.codigoLugar,
    );
    print('DEBUG(confirmarReserva): nuevaReserva = '+nuevaReserva.toJson().toString());

    // Guardar la reserva
    final reservasJson = await db.getAll("reservas.json");
    reservasJson.add(nuevaReserva.toJson());
    await db.saveAll("reservas.json", reservasJson);
    print('DEBUG(confirmarReserva): Reserva guardada en reservas.json');

    // Marcar el lugar como reservado
    final lugaresJson = await db.getAll("lugares.json");
    final index = lugaresJson.indexWhere((l) => l['codigoLugar'] == lugarSeleccionado.value!.codigoLugar);
    if (index != -1) {
      lugaresJson[index]['estado'] = "RESERVADO";
      await db.saveAll("lugares.json", lugaresJson);
      print('DEBUG(confirmarReserva): Lugar '+lugarSeleccionado.value!.codigoLugar+' marcado como RESERVADO');
    }

    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    print('DEBUG(confirmarReserva): FIN');
    return true;
  }

  void resetearCampos() {
    autoSeleccionado.value = null;
    pisoSeleccionado.value = null;
    lugarSeleccionado.value = null;
    horarioInicio.value = null;
    horarioSalida.value = null;
    duracionSeleccionada.value = 0;
  }

  @override
  void onClose() {
    resetearCampos();
    super.onClose();
  }
} 