import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../alumno/controller/pago_controller.dart';
import '../../alumno/model/pago_model.dart';
import '../../alumno/utils/utiles.dart';
import '../../widgets/custom_button.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorEstado.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getIconMetodoPago(pago.metodoPago),
                          color: colorEstado,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pago #${pago.codigoPago}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              UtilesApp.formatearFechaDdMMAaaa(pago.fechaPago),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorEstado.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pago.estadoPago,
                      style: TextStyle(
                        color: colorEstado,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reserva",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pago.codigoReservaAsociada,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Monto",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
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
                ],
              ),
              if (pago.notas != null) ...[
                const Divider(height: 24),
                Row(
                  children: [
                    Icon(
                      Icons.note,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        pago.notas!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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

  void _mostrarDialogoNuevoPago(BuildContext context) {
    final codigoController = TextEditingController();
    final montoController = TextEditingController();
    final notasController = TextEditingController();
    String metodoSeleccionado = 'EFECTIVO';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.add_circle,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            const Text("Nuevo Pago"),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codigoController,
                decoration: InputDecoration(
                  labelText: "Código de Reserva",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.confirmation_number),
                ),
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
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Registrar"),
          ),
        ],
      ),
    );
  }
} 