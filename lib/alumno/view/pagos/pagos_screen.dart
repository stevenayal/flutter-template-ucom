import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/pago_controller.dart';
import '../../model/pago_model.dart';
import '../../utils/utiles.dart';
import '../../widgets/custom_button.dart';
import '../../api/local.db.service.dart';

class AlumnoPagosScreen extends StatelessWidget {
  final controller = Get.put(AlumnoPagoController());

  AlumnoPagosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Pagos"),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildFiltros(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.pagosFiltrados.isEmpty) {
                  return const Center(
                    child: Text(
                      "No hay pagos registrados ni reservas pendientes",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.pagosFiltrados.length,
                  itemBuilder: (context, index) {
                    final item = controller.pagosFiltrados[index];
                    print('DEBUG(PagosScreen): item #$index type: '+item.runtimeType.toString()+', value: '+item.toString());
                    if (item is PagoDetallado) {
                      return _buildPagoCard(context, item);
                    } else if (item is Map && item['isReservaPendiente'] == true) {
                      // Tarjeta de reserva pendiente de pago
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.orange),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Reserva pendiente: "+item['codigoReserva'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _mostrarDialogoNuevoPago(context, reserva: Map<String, dynamic>.from(item));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Pagar ahora"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text("Auto: "+(item['chapaAuto'] ?? ''), style: const TextStyle(fontSize: 14)),
                              Text("Monto: ₲ "+(item['monto']?.toStringAsFixed(0) ?? ''), style: const TextStyle(fontSize: 14)),
                              Text("Horario: "+(item['horarioInicio'] ?? ''), style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              }),
            ),
            _buildResumenTotal(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogoNuevoPago(context),
        icon: const Icon(Icons.add),
        label: const Text("Nuevo Pago"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildFiltros() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(() => DropdownButtonFormField<String>(
                  value: controller.filtroEstado.value,
                  decoration: const InputDecoration(
                    labelText: "Estado",
                    border: OutlineInputBorder(),
                  ),
                  items: ['TODOS', 'PENDIENTE', 'COMPLETADO', 'CANCELADO']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => controller.cambiarFiltroEstado(value!),
                )),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() => DropdownButtonFormField<String>(
                  value: controller.filtroMetodo.value,
                  decoration: const InputDecoration(
                    labelText: "Método",
                    border: OutlineInputBorder(),
                  ),
                  items: ['TODOS', 'EFECTIVO', 'TARJETA', 'TRANSFERENCIA']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => controller.cambiarFiltroMetodo(value!),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPagoCard(BuildContext context, PagoDetallado pago) {
    final colorEstado = _getColorEstado(pago.estadoPago);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorEstado.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pago #${pago.codigoPago}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorEstado.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pago.estadoPago,
                    style: TextStyle(
                      color: colorEstado,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reserva: ${pago.codigoReservaAsociada}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      UtilesApp.formatearFechaDdMMAaaa(pago.fechaPago),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  UtilesApp.formatearGuaraniesConSimbolo(pago.montoPagado),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  _getIconMetodoPago(pago.metodoPago),
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  pago.metodoPago,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                if (pago.notas != null) ...[
                  const SizedBox(width: 16),
                  Icon(
                    Icons.note,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      pago.notas!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenTotal() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Obx(() => Text(
            UtilesApp.formatearGuaraniesConSimbolo(controller.totalPagos),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(Get.context!).primaryColor,
            ),
          )),
        ],
      ),
    );
  }

  Color _getColorEstado(String estado) {
    switch (estado) {
      case 'COMPLETADO':
        return Colors.green;
      case 'PENDIENTE':
        return Colors.orange;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconMetodoPago(String metodo) {
    switch (metodo) {
      case 'EFECTIVO':
        return Icons.money;
      case 'TARJETA':
        return Icons.credit_card;
      case 'TRANSFERENCIA':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  void _mostrarDialogoNuevoPago(BuildContext context, {Map<String, dynamic>? reserva}) async {
    final codigoController = TextEditingController();
    final montoController = TextEditingController();
    final notasController = TextEditingController();
    String metodoSeleccionado = 'EFECTIVO';

    // Cargar reservas pendientes del usuario logueado
    final db = controller.db;
    List reservas;
    if (reserva != null) {
      reservas = [reserva];
    } else {
      reservas = await db.getAll("reservas.json");
      reservas = reservas.where((r) =>
        r['estadoReserva'] == 'PENDIENTE' &&
        r['clienteId'] == controller.codigoClienteActual
      ).toList();
    }

    if (reservas.isEmpty) {
      Get.snackbar(
        'Sin reservas pendientes',
        'No hay reservas pendientes de pago',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nuevo Pago"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Map<String, dynamic>>(
                value: reserva,
                decoration: const InputDecoration(
                  labelText: "Seleccionar Reserva",
                  border: OutlineInputBorder(),
                ),
                items: reservas.map<DropdownMenuItem<Map<String, dynamic>>>((res) {
                  final monto = res['monto'] as double;
                  final fechaInicio = DateTime.parse(res['horarioInicio']);
                  final fechaFin = DateTime.parse(res['horarioSalida']);
                  final chapa = res['chapaAuto'] as String;
                  return DropdownMenuItem(
                    value: res,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Reserva: "+res['codigoReserva'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("Auto: $chapa", style: const TextStyle(fontSize: 12)),
                        Text("Monto: ₲ ${monto.toStringAsFixed(0)}", style: const TextStyle(fontSize: 12)),
                        Text("Horario: ${fechaInicio.day}/${fechaInicio.month}/${fechaInicio.year} - ${fechaFin.day}/${fechaFin.month}/${fechaFin.year}", style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (res) {
                  if (res != null) {
                    codigoController.text = res['codigoReserva'];
                    montoController.text = res['monto'].toString();
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: montoController,
                decoration: const InputDecoration(
                  labelText: "Monto",
                  border: OutlineInputBorder(),
                  prefixText: "₲ ",
                ),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: metodoSeleccionado,
                decoration: const InputDecoration(
                  labelText: "Método de Pago",
                  border: OutlineInputBorder(),
                ),
                items: ['EFECTIVO', 'TARJETA', 'TRANSFERENCIA']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => metodoSeleccionado = value!,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notasController,
                decoration: const InputDecoration(
                  labelText: "Notas (opcional)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (codigoController.text.isEmpty || montoController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Por favor complete todos los campos requeridos',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              final nuevoPago = PagoDetallado(
                codigoPago: "PAG-${DateTime.now().millisecondsSinceEpoch}",
                codigoReservaAsociada: codigoController.text,
                montoPagado: double.parse(montoController.text),
                fechaPago: DateTime.now(),
                metodoPago: metodoSeleccionado,
                estadoPago: 'COMPLETADO',
                notas: notasController.text.isEmpty ? null : notasController.text,
              );

              controller.registrarPago(nuevoPago);
              Navigator.pop(context);
            },
            child: const Text("Registrar"),
          ),
        ],
      ),
    );
  }
} 