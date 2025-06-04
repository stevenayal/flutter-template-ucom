// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/local.db.service.dart';
import '../model/pago_model.dart';
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
    print('DEBUG(Controller): Accessing pagosFiltrados getter (IGNORING FILTERS).');
    print('DEBUG(Controller): Returning all ${pagos.length} payments.');
    return pagos.toList();
  }

  double get totalPagos {
    print('DEBUG(Controller): Accessing totalPagos getter.');
    final total = pagosFiltrados.fold(0.0, (sum, pago) => sum + pago.montoPagado);
    print('DEBUG(Controller): Calculated total for payments: $total');
    return total;
  }

  Future<void> registrarPago(PagoDetallado nuevoPago) async {
    print('DEBUG(Controller): Attempting to register new payment: ${nuevoPago.codigoPago}');
    try {
      isLoading.value = true;
      final pagosActuales = await db.getAll("pagos.json");
      pagosActuales.add(nuevoPago.toJson());
      await db.saveAll("pagos.json", pagosActuales);
      print('DEBUG(Controller): Successfully saved new payment to pagos.json');

      print('DEBUG(Controller): Calling cargarPagos after registering new payment to refresh list.');
      await cargarPagos();
      
      Get.snackbar(
        'Éxito',
        'Pago registrado correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print('DEBUG(Controller): New payment registered successfully.');

    } catch (e) {
      print("ERROR(Controller): Error al registrar pago: $e");
      Get.snackbar(
        'Error',
        'No se pudo registrar el pago',
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