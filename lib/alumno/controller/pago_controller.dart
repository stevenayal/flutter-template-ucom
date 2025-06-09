// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/local.db.service.dart';
import '../model/pago_model.dart';
import '../model/sistema_reservas.dart';
import '../utils/utiles.dart';

class AlumnoPagoController extends GetxController {
  final db = LocalDBService();
  final RxList<PagoDetallado> pagos = <PagoDetallado>[].obs;
  final RxBool isLoading = false.obs;
  final RxString filtroEstado = 'TODOS'.obs;
  final RxString filtroMetodo = 'TODOS'.obs;

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

      pagos.value = data.map((json) => PagoDetallado.fromJson(json)).toList();
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

  List<PagoDetallado> get pagosFiltrados {
    print('DEBUG(Controller): Accessing pagosFiltrados getter.');
    return pagos.toList();
  }

  double get totalPagos {
    print('DEBUG(Controller): Accessing totalPagos getter.');
    final total = pagosFiltrados.fold(0.0, (sum, pago) => sum + pago.montoPagado);
    print('DEBUG(Controller): Calculated total for payments: $total');
    return total;
  }

  Future<bool> _actualizarReservaYEstacionamiento(String codigoReserva) async {
    try {
      // 1. Actualizar el estado de la reserva
      final reservas = await db.getAll("reservas.json");
      final reservaIndex = reservas.indexWhere((r) => r['codigoReserva'] == codigoReserva);
      
      if (reservaIndex == -1) {
        print("ERROR(Controller): No se encontró la reserva $codigoReserva");
        return false;
      }

      // Actualizar estado de la reserva a COMPLETADO
      reservas[reservaIndex]['estadoReserva'] = 'COMPLETADO';
      await db.saveAll("reservas.json", reservas);
      print('DEBUG(Controller): Reserva $codigoReserva actualizada a COMPLETADO');

      // 2. Liberar el lugar de estacionamiento
      final lugares = await db.getAll("lugares.json");
      final lugarIndex = lugares.indexWhere((l) => l['codigoLugar'] == codigoReserva);
      
      if (lugarIndex != -1) {
        lugares[lugarIndex]['estado'] = 'DISPONIBLE';
        await db.saveAll("lugares.json", lugares);
        print('DEBUG(Controller): Lugar de estacionamiento liberado');
      } else {
        print("WARNING(Controller): No se encontró el lugar asociado a la reserva $codigoReserva");
      }

      return true;
    } catch (e) {
      print("ERROR(Controller): Error al actualizar reserva y estacionamiento: $e");
      return false;
    }
  }

  Future<void> registrarPago(PagoDetallado nuevoPago) async {
    print('DEBUG(Controller): Attempting to register new payment: ${nuevoPago.codigoPago}');
    try {
      isLoading.value = true;

      // 1. Verificar que la reserva existe y está pendiente
      final reservas = await db.getAll("reservas.json");
      final reservaIndex = reservas.indexWhere((r) => r['codigoReserva'] == nuevoPago.codigoReservaAsociada);
      if (reservaIndex == -1) {
        throw Exception('No se encontró la reserva asociada');
      }
      final reserva = reservas[reservaIndex];

      if (reserva == null) {
        throw Exception('No se encontró la reserva asociada');
      }

      if (reserva['estadoReserva'] != 'PENDIENTE') {
        throw Exception('La reserva ya no está pendiente');
      }

      // 2. Registrar el pago
      final pagosActuales = await db.getAll("pagos.json");
      pagosActuales.add(nuevoPago.toJson());
      await db.saveAll("pagos.json", pagosActuales);
      print('DEBUG(Controller): Successfully saved new payment to pagos.json');

      // 3. Actualizar reserva y liberar estacionamiento
      final success = await _actualizarReservaYEstacionamiento(nuevoPago.codigoReservaAsociada);
      if (!success) {
        throw Exception('Error al actualizar el estado de la reserva y el estacionamiento');
      }

      // 4. Recargar la lista de pagos
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