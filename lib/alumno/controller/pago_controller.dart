// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/local.db.service.dart';
import '../model/pago_model.dart';
import '../model/sistema_reservas.dart';
import '../utils/utiles.dart';

class AlumnoPagoController extends GetxController {
  final db = LocalDBService();
  final RxList<PagoDetallado> pagos = <PagoDetallado>[].obs;
  final RxBool isLoading = false.obs;
  final RxString filtroEstado = 'TODOS'.obs;
  final RxString filtroMetodo = 'TODOS'.obs;
  String codigoClienteActual = 'cliente_1'; // TODO: Obtener del login

  // Cache de reservas para pagosFiltrados
  List<Map<String, dynamic>> cacheReservas = [];

  @override
  void onInit() {
    super.onInit();
    print('DEBUG(Controller): AlumnoPagoController initialized.');
    cargarPagos();
  }

  Future<void> cargarPagos() async {
    print('DEBUG(Controller): Attempting to load payments...');
    try {
      isLoading.value = true;
      final data = await db.getAll("pagos.json");
      print('DEBUG(Controller): Loaded ${data.length} raw payment records from pagos.json');
      final reservas = await db.getAll("reservas.json");
      cacheReservas = reservas;
      print('DEBUG(Controller): Loaded ${reservas.length} reservas from reservas.json: '+reservas.toString());
      final reservasCliente = reservas.where((r) => 
        r['clienteId'] == codigoClienteActual
      ).map((r) => r['codigoReserva'] as String).toSet();
      print('DEBUG(Controller): reservasCliente = '+reservasCliente.toString());
      pagos.value = data
        .map((json) => PagoDetallado.fromJson(json))
        .where((pago) => reservasCliente.contains(pago.codigoReservaAsociada))
        .toList();
      print('DEBUG(Controller): pagos.value = '+pagos.toString());
      print('DEBUG(Controller): Converted ${pagos.length} raw records to PagoDetallado objects.');
    } catch (e) {
      print("ERROR(Controller): Error al cargar pagos: $e");
      Get.snackbar(
        'Error',
        'No se pudieron cargar los pagos',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      print('DEBUG(Controller): isLoading set to false.');
    }
  }

  List<dynamic> get pagosFiltrados {
    print('DEBUG(Controller): Accessing pagosFiltrados getter.');
    var filtered = pagos.toList();
    if (filtroEstado.value != 'TODOS') {
      filtered = filtered.where((p) {
        if (p is PagoDetallado) {
          return p.estadoPago == filtroEstado.value;
        } else {
          print('WARNING(Controller): Elemento no es PagoDetallado en filtroEstado: '+p.runtimeType.toString());
          return false;
        }
      }).toList();
    }
    if (filtroMetodo.value != 'TODOS') {
      filtered = filtered.where((p) {
        if (p is PagoDetallado) {
          return p.metodoPago == filtroMetodo.value;
        } else {
          print('WARNING(Controller): Elemento no es PagoDetallado en filtroMetodo: '+p.runtimeType.toString());
          return false;
        }
      }).toList();
    }
    // Cargar reservas pendientes de pago (sin pago asociado)
    final List<Map<String, dynamic>> reservasPendientes = [];
    final reservasRaw = cacheReservas;
    final pagosRaw = pagos;
    final reservasConPago = pagosRaw.map((p) => p.codigoReservaAsociada).toSet();
    // Solo mostrar reservas pendientes si el filtro de estado es TODOS o PENDIENTE
    if (filtroEstado.value == 'TODOS' || filtroEstado.value == 'PENDIENTE') {
      for (final r in reservasRaw) {
        if (r['clienteId'] == codigoClienteActual &&
            r['estadoReserva'] == 'PENDIENTE' &&
            !reservasConPago.contains(r['codigoReserva'])) {
          reservasPendientes.add({...r, 'isReservaPendiente': true});
        }
      }
    }
    final result = [
      ...reservasPendientes,
      ...filtered
    ];
    print('DEBUG(Controller): pagosFiltrados result types: '+result.map((e) => e.runtimeType.toString()).join(", "));
    return result;
  }

  double get totalPagos {
    print('DEBUG(Controller): Accessing totalPagos getter.');
    double total = 0.0;
    for (final pago in pagosFiltrados) {
      if (pago is PagoDetallado) {
        total += pago.montoPagado;
      } else if (pago is Map && pago['isReservaPendiente'] == true) {
        try {
          final monto = pago['monto'];
          if (monto is num) {
            total += monto.toDouble();
          } else {
            print('WARNING(Controller): Monto de reserva pendiente no es num: '+monto.toString());
          }
        } catch (e) {
          print('ERROR(Controller): Error al sumar monto de reserva pendiente: '+e.toString());
        }
      } else {
        print('WARNING(Controller): Elemento inesperado en totalPagos: '+pago.runtimeType.toString());
      }
    }
    print('DEBUG(Controller): Calculated total for payments: $total');
    return total;
  }

  Future<bool> _actualizarReservaYEstacionamiento(String codigoReserva) async {
    try {
      // 1. Obtener la reserva y verificar que pertenece al cliente actual
      final reservas = await db.getAll("reservas.json");
      final reservaIndex = reservas.indexWhere((r) => 
        r['codigoReserva'] == codigoReserva && 
        r['clienteId'] == codigoClienteActual
      );
      
      if (reservaIndex == -1) {
        print("ERROR(Controller): No se encontró la reserva $codigoReserva para el cliente actual");
        return false;
      }

      final reserva = reservas[reservaIndex];
      final codigoLugar = reserva['codigoLugar']; // Obtener el código del lugar de la reserva

      // 2. Actualizar estado de la reserva a COMPLETADO
      reservas[reservaIndex]['estadoReserva'] = 'COMPLETADO';
      await db.saveAll("reservas.json", reservas);
      print('DEBUG(Controller): Reserva $codigoReserva actualizada a COMPLETADO');

      // 3. Liberar el lugar de estacionamiento usando el código correcto
      final lugares = await db.getAll("lugares.json");
      final lugarIndex = lugares.indexWhere((l) => l['codigoLugar'] == codigoLugar);
      
      if (lugarIndex != -1) {
        lugares[lugarIndex]['estado'] = 'DISPONIBLE';
        await db.saveAll("lugares.json", lugares);
        print('DEBUG(Controller): Lugar de estacionamiento $codigoLugar liberado');
      } else {
        print("WARNING(Controller): No se encontró el lugar $codigoLugar asociado a la reserva $codigoReserva");
      }

      return true;
    } catch (e) {
      print("ERROR(Controller): Error al actualizar reserva y estacionamiento: $e");
      return false;
    }
  }

  Future<void> registrarPago(PagoDetallado nuevoPago) async {
    print('DEBUG(Controller): Attempting to register new payment: '+nuevoPago.toJson().toString());
    try {
      isLoading.value = true;
      final reservas = await db.getAll("reservas.json");
      print('DEBUG(Controller): reservas.json = '+reservas.toString());
      final reservaIndex = reservas.indexWhere((r) => 
        r['codigoReserva'] == nuevoPago.codigoReservaAsociada &&
        r['clienteId'] == codigoClienteActual
      );
      print('DEBUG(Controller): reservaIndex = $reservaIndex');
      if (reservaIndex == -1) {
        throw Exception('No se encontró la reserva asociada o no pertenece al cliente actual');
      }
      final reserva = reservas[reservaIndex];
      if (reserva['estadoReserva'] != 'PENDIENTE') {
        throw Exception('La reserva ya no está pendiente');
      }
      final pagosActuales = await db.getAll("pagos.json");
      print('DEBUG(Controller): pagosActuales antes de agregar = '+pagosActuales.toString());
      pagosActuales.add(nuevoPago.toJson());
      await db.saveAll("pagos.json", pagosActuales);
      print('DEBUG(Controller): Successfully saved new payment to pagos.json');
      final success = await _actualizarReservaYEstacionamiento(nuevoPago.codigoReservaAsociada);
      if (!success) {
        throw Exception('Error al actualizar el estado de la reserva y el estacionamiento');
      }
      await cargarPagos();
      Get.snackbar(
        'Éxito',
        'Pago registrado y reserva completada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print('DEBUG(Controller): New payment registered successfully.');
    } catch (e) {
      print("ERROR(Controller): Error al registrar pago: $e");
      Get.snackbar(
        'Error',
        'No se pudo registrar el pago: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      print('DEBUG(Controller): isLoading set to false after registration.');
    }
  }

  void cambiarFiltroEstado(String estado) {
    print('DEBUG(Controller): Changing filter state to $estado');
    filtroEstado.value = estado;
  }

  void cambiarFiltroMetodo(String metodo) {
    print('DEBUG(Controller): Changing filter method to $metodo');
    filtroMetodo.value = metodo;
  }
} 