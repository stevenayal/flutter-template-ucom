// ignore_for_file: deprecated_member_use

import 'package:finpay/api/local.db.service.dart';
import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/model/sitema_reservas.dart';
import 'package:finpay/alumno/model/pago_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class HomeController extends GetxController {
  // Log tags para mejor organización
  static const String _TAG = "HomeController";
  
  // Estado de carga
  RxBool isLoading = false.obs;
  RxString lastError = ''.obs;
  RxBool hasError = false.obs;

  RxBool isWeek = true.obs;
  RxBool isMonth = false.obs;
  RxBool isYear = false.obs;
  RxList<PagoDetallado> pagosPrevios = <PagoDetallado>[].obs;

  // Estadísticas de estacionamiento
  RxInt reservasMesActual = 0.obs;
  RxInt reservasPendientes = 0.obs;
  RxInt reservasCompletadas = 0.obs;
  RxInt reservasCanceladas = 0.obs;
  RxInt cantidadAutos = 0.obs;
  RxDouble montoTotalMes = 0.0.obs;
  RxDouble montoPendiente = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    developer.log('Inicializando $_TAG', name: _TAG);
    customInit();
  }

  @override
  void onClose() {
    developer.log('Cerrando $_TAG', name: _TAG);
    super.onClose();
  }

  customInit() async {
    developer.log('Iniciando carga de datos del estacionamiento...', name: _TAG);
    try {
      isLoading.value = true;
      hasError.value = false;
      lastError.value = '';

      await cargarPagosPrevios();
      await actualizarEstadisticasEstacionamiento();
      
      developer.log('Carga de datos completada exitosamente', name: _TAG);
      developer.log('Estado actual:', name: _TAG);
      developer.log('- Reservas del mes: ${reservasMesActual.value}', name: _TAG);
      developer.log('- Reservas pendientes: ${reservasPendientes.value}', name: _TAG);
      developer.log('- Reservas completadas: ${reservasCompletadas.value}', name: _TAG);
      developer.log('- Reservas canceladas: ${reservasCanceladas.value}', name: _TAG);
      developer.log('- Autos registrados: ${cantidadAutos.value}', name: _TAG);
      developer.log('- Monto total del mes: ${montoTotalMes.value}', name: _TAG);
      developer.log('- Monto pendiente: ${montoPendiente.value}', name: _TAG);
      developer.log('- Total de pagos previos: ${pagosPrevios.length}', name: _TAG);

    } catch (e, st) {
      developer.log('Error durante customInit: $e', name: _TAG, error: e, stackTrace: st);
      hasError.value = true;
      lastError.value = 'Error al cargar datos: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }

    isWeek.value = true;
    isMonth.value = false;
    isYear.value = false;
  }

  Future<void> actualizarEstadisticasEstacionamiento() async {
    developer.log('Actualizando estadísticas de estacionamiento...', name: _TAG);
    try {
      final db = LocalDBService();
      
      // Obtener todas las reservas y pagos
      developer.log('Obteniendo datos de la base de datos...', name: _TAG);
      final reservas = await db.getAll("reservas.json");
      final pagos = await db.getAll("pagos.json");
      
      developer.log('Datos obtenidos:', name: _TAG);
      developer.log('- Total reservas: ${reservas.length}', name: _TAG);
      developer.log('- Total pagos: ${pagos.length}', name: _TAG);
      
      // Fechas para filtrado
      final ahora = DateTime.now();
      final inicioMes = DateTime(ahora.year, ahora.month, 1);
      
      // 1. Estadísticas de reservas
      developer.log('Calculando estadísticas de reservas...', name: _TAG);
      reservasMesActual.value = reservas.where((r) {
        try {
          final fechaReserva = DateTime.parse(r['fechaReserva']);
          return fechaReserva.isAfter(inicioMes) && fechaReserva.isBefore(ahora);
        } catch (e) {
          developer.log('Error al procesar fecha de reserva: $e', name: _TAG, error: e);
          return false;
        }
      }).length;

      // 2. Estados de reservas
      developer.log('Calculando estados de reservas...', name: _TAG);
      reservasPendientes.value = reservas.where((r) => r['estadoReserva'] == 'PENDIENTE').length;
      developer.log('- Reservas Pendientes calculadas: ${reservasPendientes.value}', name: _TAG);
      reservasCompletadas.value = reservas.where((r) => r['estadoReserva'] == 'COMPLETADA').length;
      developer.log('- Reservas Completadas calculadas: ${reservasCompletadas.value}', name: _TAG);
      reservasCanceladas.value = reservas.where((r) => r['estadoReserva'] == 'CANCELADA').length;
      developer.log('- Reservas Canceladas calculadas: ${reservasCanceladas.value}', name: _TAG);

      // 3. Autos únicos
      developer.log('Calculando autos únicos...', name: _TAG);
      final autos = <String>{};
      for (var r in reservas) {
        try {
          if (r['chapaAuto'] != null) autos.add(r['chapaAuto']);
        } catch (e) {
          developer.log('Error al procesar chapa de auto: $e', name: _TAG, error: e);
        }
      }
      cantidadAutos.value = autos.length;

      // 4. Montos
      developer.log('Calculando montos...', name: _TAG);
      montoTotalMes.value = pagos.where((p) {
        try {
          final fechaPago = DateTime.parse(p['fechaPago']);
          return fechaPago.isAfter(inicioMes) && fechaPago.isBefore(ahora);
        } catch (e) {
          developer.log('Error al procesar fecha de pago: $e', name: _TAG, error: e);
          return false;
        }
      }).fold(0.0, (sum, p) {
        try {
          final monto = p['montoPagado'] ?? 0.0;
          developer.log('Procesando pago - monto: $monto', name: _TAG);
          return sum + monto;
        } catch (e) {
          developer.log('Error al procesar monto de pago: $e', name: _TAG, error: e);
          return sum;
        }
      });
      developer.log('- Monto Total del Mes calculado: ${montoTotalMes.value}', name: _TAG);

      // Monto pendiente
      montoPendiente.value = reservas.where((r) => r['estadoReserva'] == 'PENDIENTE')
          .fold(0.0, (sum, r) {
        try {
          final monto = r['montoReserva'] ?? 0.0;
          developer.log('Procesando reserva pendiente - monto: $monto', name: _TAG);
          return sum + monto;
        } catch (e) {
          developer.log('Error al procesar monto de reserva pendiente: $e', name: _TAG, error: e);
          return sum;
        }
      });
      developer.log('- Monto Pendiente calculado: ${montoPendiente.value}', name: _TAG);

      developer.log('Estadísticas actualizadas exitosamente', name: _TAG);
    } catch (e, st) {
      developer.log('Error al actualizar estadísticas: $e', name: _TAG, error: e, stackTrace: st);
      hasError.value = true;
      lastError.value = 'Error al actualizar estadísticas: ${e.toString()}';
      rethrow;
    }
  }

  Future<void> cargarPagosPrevios() async {
    developer.log('Cargando pagos previos...', name: _TAG);
    try {
      final db = LocalDBService();
      final data = await db.getAll("pagos.json");
      
      developer.log('Pagos obtenidos de la base de datos: ${data.length}', name: _TAG);

      // Ordenar pagos por fecha, más recientes primero
      pagosPrevios.value = data
          .map((json) {
            try {
              return PagoDetallado.fromJson(json);
            } catch (e) {
              developer.log('Error al convertir pago: $e', name: _TAG, error: e);
              return null;
            }
          })
          .where((pago) => pago != null)
          .cast<PagoDetallado>()
          .toList()
        ..sort((a, b) => b.fechaPago.compareTo(a.fechaPago));

      developer.log('Pagos previos cargados exitosamente: ${pagosPrevios.length}', name: _TAG);
      if (pagosPrevios.isNotEmpty) {
        developer.log('Último pago: ${pagosPrevios.first.codigoPago}', name: _TAG);
      }
    } catch (e, st) {
      developer.log('Error al cargar pagos previos: $e', name: _TAG, error: e, stackTrace: st);
      hasError.value = true;
      lastError.value = 'Error al cargar pagos previos: ${e.toString()}';
      rethrow;
    }
  }

  // Método para reintentar la carga de datos
  Future<void> retryLoading() async {
    developer.log('Reintentando carga de datos...', name: _TAG);
    await customInit();
  }
}
