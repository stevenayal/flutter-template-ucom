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
    cargarPagos();
  }

  Future<void> cargarPagos() async {
    try {
      isLoading.value = true;
      final data = await db.getAll("pagos.json");
      print('DEBUG: Loaded ${data.length} raw payment records from pagos.json');
      pagos.value = data.map((json) => PagoDetallado.fromJson(json)).toList();
      print('DEBUG: Converted ${pagos.length} payment records to PagoDetallado objects.');
    } catch (e) {
      print("Error al cargar pagos: $e");
      Get.snackbar(
        'Error',
        'No se pudieron cargar los pagos',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<PagoDetallado> get pagosFiltrados {
    return pagos.where((pago) {
      final estadoMatch = filtroEstado.value == 'TODOS' || pago.estadoPago == filtroEstado.value;
      final metodoMatch = filtroMetodo.value == 'TODOS' || pago.metodoPago == filtroMetodo.value;
      final match = estadoMatch && metodoMatch;
      print('DEBUG: Filtering pago ${pago.codigoPago} - Estado: ${pago.estadoPago}, Metodo: ${pago.metodoPago}. Match: $match');
      return match;
    }).toList();
  }

  double get totalPagos {
    final total = pagosFiltrados.fold(0.0, (sum, pago) => sum + pago.montoPagado);
    print('DEBUG: Calculated total for filtered payments: $total');
    return total;
  }

  Future<void> registrarPago(PagoDetallado nuevoPago) async {
    try {
      isLoading.value = true;
      final pagosActuales = await db.getAll("pagos.json");
      pagosActuales.add(nuevoPago.toJson());
      await db.saveAll("pagos.json", pagosActuales);
      print('DEBUG: Successfully saved new payment to pagos.json');

      print('DEBUG: Calling cargarPagos after registering new payment.');
      await cargarPagos();
      
      Get.snackbar(
        'Éxito',
        'Pago registrado correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error al registrar pago: $e");
      Get.snackbar(
        'Error',
        'No se pudo registrar el pago',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void cambiarFiltroEstado(String estado) {
    filtroEstado.value = estado;
  }

  void cambiarFiltroMetodo(String metodo) {
    filtroMetodo.value = metodo;
  }
} 