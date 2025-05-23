import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/reserva_controller.dart';
import '../../model/sistema_reservas.dart';
import '../../utils/utiles.dart';
import '../../widgets/custom_button.dart';

class AlumnoReservaScreen extends StatelessWidget {
  final controller = Get.put(AlumnoReservaController());

  AlumnoReservaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservar lugar"),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Seleccionar auto",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Obx(() {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<Auto>(
                              isExpanded: true,
                              value: controller.autoSeleccionado.value,
                              hint: const Text("Seleccionar auto"),
                              underline: const SizedBox(),
                              onChanged: (auto) {
                                controller.autoSeleccionado.value = auto;
                              },
                              items: controller.autosCliente.map((a) {
                                final nombre = "${a.chapa} - ${a.marca} ${a.modelo}";
                                return DropdownMenuItem(value: a, child: Text(nombre));
                              }).toList(),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Seleccionar piso",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Obx(() {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<Piso>(
                              isExpanded: true,
                              value: controller.pisoSeleccionado.value,
                              hint: const Text("Seleccionar piso"),
                              underline: const SizedBox(),
                              onChanged: (p) => controller.seleccionarPiso(p!),
                              items: controller.pisos
                                  .map((p) => DropdownMenuItem(
                                      value: p, child: Text(p.descripcion)))
                                  .toList(),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Seleccionar lugar",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 200,
                          child: GridView.count(
                            crossAxisCount: 5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            children: controller.lugaresDisponibles
                                .where((l) =>
                                    l.codigoPiso ==
                                    controller.pisoSeleccionado.value?.codigo)
                                .map((lugar) {
                              final seleccionado =
                                  lugar == controller.lugarSeleccionado.value;
                              final color = lugar.estado == "RESERVADO"
                                  ? Colors.red
                                  : seleccionado
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade300;

                              return GestureDetector(
                                onTap: lugar.estado == "DISPONIBLE"
                                    ? () => controller.lugarSeleccionado.value = lugar
                                    : null,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: color,
                                    border: Border.all(
                                        color: seleccionado
                                            ? Theme.of(context).primaryColor
                                            : Colors.black12),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    lugar.codigoLugar,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: lugar.estado == "RESERVADO"
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Seleccionar horarios",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Theme.of(context).primaryColor,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime.now().add(const Duration(days: 30)),
                                  );
                                  if (date == null) return;
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (time == null) return;
                                  controller.horarioInicio.value = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  );
                                },
                                icon: const Icon(Icons.access_time),
                                label: Obx(() => Text(
                                      controller.horarioInicio.value == null
                                          ? "Inicio"
                                          : "${UtilesApp.formatearFechaDdMMAaaa(controller.horarioInicio.value!)} ${TimeOfDay.fromDateTime(controller.horarioInicio.value!).format(context)}",
                                    )),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Theme.of(context).primaryColor,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: controller.horarioInicio.value ??
                                        DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime.now().add(const Duration(days: 30)),
                                  );
                                  if (date == null) return;
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (time == null) return;
                                  controller.horarioSalida.value = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  );
                                },
                                icon: const Icon(Icons.timer_off),
                                label: Obx(() => Text(
                                      controller.horarioSalida.value == null
                                          ? "Salida"
                                          : "${UtilesApp.formatearFechaDdMMAaaa(controller.horarioSalida.value!)} ${TimeOfDay.fromDateTime(controller.horarioSalida.value!).format(context)}",
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Duración rápida",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [1, 2, 4, 6, 8].map((horas) {
                            final seleccionada =
                                controller.duracionSeleccionada.value == horas;
                            return ChoiceChip(
                              label: Text("$horas h"),
                              selected: seleccionada,
                              selectedColor: Theme.of(context).primaryColor,
                              backgroundColor: Colors.grey[100],
                              labelStyle: TextStyle(
                                color: seleccionada ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              onSelected: (_) {
                                controller.duracionSeleccionada.value = horas;
                                final inicio =
                                    controller.horarioInicio.value ?? DateTime.now();
                                controller.horarioInicio.value = inicio;
                                controller.horarioSalida.value =
                                    inicio.add(Duration(hours: horas));
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    final inicio = controller.horarioInicio.value;
                    final salida = controller.horarioSalida.value;

                    if (inicio == null || salida == null) return const SizedBox.shrink();

                    final minutos = salida.difference(inicio).inMinutes;
                    final horas = minutos / 60;
                    final monto = (horas * 10000).round();

                    return Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Monto estimado:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            UtilesApp.formatearGuaraniesConSimbolo(monto.toDouble()),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  CustomButton(
                    onPressed:
                        controller.lugarSeleccionado.value != null &&
                                controller.horarioInicio.value != null &&
                                controller.horarioSalida.value != null &&
                                controller.autoSeleccionado.value != null
                            ? () async {
                                final success =
                                    await controller.confirmarReserva();
                                if (success) {
                                  Get.snackbar(
                                    'Reserva Exitosa',
                                    'Tu lugar ha sido reservado.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                  controller.resetearCampos();
                                } else {
                                  Get.snackbar(
                                    'Error al Reservar',
                                    'No se pudo completar la reserva. Intenta de nuevo.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.redAccent,
                                    colorText: Colors.white,
                                  );
                                }
                              }
                            : null,
                    buttonText: "Confirmar Reserva",
                    isLoading: controller.isLoading.value,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
} 