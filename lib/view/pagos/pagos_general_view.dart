import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../alumno/controller/pago_controller.dart';
import '../../alumno/model/pago_model.dart';
import '../../alumno/utils/utiles.dart';
import '../../widgets/custom_button.dart';
import '../../alumno/api/local.db.service.dart';

class PagosGeneralView extends StatelessWidget {
  // Reutilizamos el controlador de alumno pero con un nombre diferente
  final controller = Get.put(AlumnoPagoController(), tag: 'pagos_general');

  PagosGeneralView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pagos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementar filtros avanzados
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildResumenCards(),
            _buildFiltros(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.pagosFiltrados.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payment,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No hay pagos registrados",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.pagosFiltrados.length,
                  itemBuilder: (context, index) {
                    final pago = controller.pagosFiltrados[index];
                    return _buildPagoCard(context, pago);
                  },
                );
              }),
            ),
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

  Widget _buildResumenCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildResumenCard(
              "Total Pagos",
              UtilesApp.formatearGuaraniesConSimbolo(controller.totalPagos),
              Icons.account_balance_wallet,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildResumenCard(
              "Pendientes",
              UtilesApp.formatearGuaraniesConSimbolo(
                controller.pagosFiltrados
                    .where((p) => p.estadoPago == 'PENDIENTE')
                    .fold(0, (sum, p) => sum + p.montoPagado),
              ),
              Icons.pending_actions,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenCard(String title, String amount, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltros() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => DropdownButtonFormField<String>(
              value: controller.filtroEstado.value,
              decoration: InputDecoration(
                labelText: "Estado",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                filled: true,
                fillColor: Colors.white,
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
              decoration: InputDecoration(
                labelText: "Método",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                filled: true,
                fillColor: Colors.white,
              ),
              items: ['TODOS', 'EFECTIVO', 'TARJETA', 'TRANSFERENCIA']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => controller.cambiarFiltroMetodo(value!),
            )),
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
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorEstado.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implementar vista detallada del pago
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pago #${pago.codigoPago}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Reserva: ${pago.codigoReservaAsociada}",
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                "Monto: ${UtilesApp.formatearGuaraniesConSimbolo(pago.montoPagado)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Fecha: ${UtilesApp.formatearFechaDdMMAaaa(pago.fechaPago)}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Estado: ${pago.estadoPago}",
                style: TextStyle(
                  fontSize: 14,
                  color: _getColorEstado(pago.estadoPago),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (pago.notas != null) ...[
                const SizedBox(height: 4),
                Text(
                  "Notas: ${pago.notas!}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
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

  void _mostrarDialogoNuevoPago(BuildContext context) async {
    final codigoController = TextEditingController();
    final montoController = TextEditingController();
    final notasController = TextEditingController();
    String metodoSeleccionado = 'EFECTIVO';
    bool isLoading = false;

    // Cargar reservas pendientes
    final db = LocalDBService();
    final reservas = await db.getAll("reservas.json");
    final reservasPendientes = reservas.where((r) => r['estadoReserva'] == 'PENDIENTE').toList();

    if (reservasPendientes.isEmpty) {
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
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.payment,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              const Text("Registrar Pago"),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Map<String, dynamic>>(
                  value: null,
                  decoration: InputDecoration(
                    labelText: "Seleccionar Reserva",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.confirmation_number),
                  ),
                  items: reservasPendientes.map((reserva) {
                    final monto = reserva['monto'] as double;
                    final fechaInicio = DateTime.parse(reserva['horarioInicio']);
                    final fechaFin = DateTime.parse(reserva['horarioSalida']);
                    final chapa = reserva['chapaAuto'] as String;
                    
                    return DropdownMenuItem(
                      value: reserva,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Reserva: ${reserva['codigoReserva']}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Auto: $chapa",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          Text(
                            "Monto: ${UtilesApp.formatearGuaraniesConSimbolo(monto)}",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          Text(
                            "Horario: ${UtilesApp.formatearFechaDdMMAaaa(fechaInicio)} - ${UtilesApp.formatearFechaDdMMAaaa(fechaFin)}",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (reserva) {
                    if (reserva != null) {
                      codigoController.text = reserva['codigoReserva'];
                      montoController.text = reserva['monto'].toString();
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: montoController,
                  decoration: InputDecoration(
                    labelText: "Monto",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.attach_money),
                    prefixText: "₲ ",
                  ),
                  keyboardType: TextInputType.number,
                  readOnly: true, // El monto viene de la reserva
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: metodoSeleccionado,
                  decoration: InputDecoration(
                    labelText: "Método de Pago",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(_getIconMetodoPago(metodoSeleccionado)),
                  ),
                  items: ['EFECTIVO', 'TARJETA', 'TRANSFERENCIA']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => metodoSeleccionado = value!,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notasController,
                  decoration: InputDecoration(
                    labelText: "Notas (opcional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.note),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (codigoController.text.isEmpty || montoController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Por favor seleccione una reserva',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      setState(() => isLoading = true);

                      try {
                        final nuevoPago = PagoDetallado(
                          codigoPago: "PAG-${DateTime.now().millisecondsSinceEpoch}",
                          codigoReservaAsociada: codigoController.text,
                          montoPagado: double.parse(montoController.text),
                          fechaPago: DateTime.now(),
                          metodoPago: metodoSeleccionado,
                          estadoPago: 'COMPLETADO',
                          notas: notasController.text.isEmpty ? null : notasController.text,
                        );

                        await controller.registrarPago(nuevoPago);
                        Navigator.pop(context);
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text("Registrar Pago"),
            ),
          ],
        ),
      ),
    );
  }
} 