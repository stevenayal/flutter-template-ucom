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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Seleccionar auto",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            TextButton.icon(
                              onPressed: () => _mostrarDialogoAgregarAuto(context),
                              icon: const Icon(Icons.add),
                              label: const Text("Agregar auto"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          if (controller.autosCliente.isEmpty) {
                            return const Text(
                              "No tienes autos registrados. Agrega uno para poder reservar.",
                              style: TextStyle(color: Colors.redAccent),
                            );
                          }
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
                          print("DEBUG (dropdown pisos): controller.pisoSeleccionado = "+(controller.pisoSeleccionado.value?.codigo ?? 'null'));
                          final dropdownValue = controller.pisos.firstWhereOrNull((p) => p.codigo == controller.pisoSeleccionado.value?.codigo);
                          print("DEBUG (dropdown pisos): dropdown value (firstWhereOrNull) = "+(dropdownValue?.codigo ?? 'null'));
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<Piso>(
                              isExpanded: true,
                              value: dropdownValue,
                              hint: const Text("Seleccionar piso"),
                              underline: const SizedBox(),
                              onChanged: (p) => controller.seleccionarPiso(p!),
                              items: controller.pisos
                                  .map((p) => DropdownMenuItem(value: p, child: Text(p.descripcion)))
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
                              // Determinar si el lugar está ocupado por una reserva
                              final reservasLugar = controller.db != null ? [] : [];
                              // Si tienes acceso a las reservas en el controlador, puedes usarlo aquí
                              // Por ahora, usamos el estado del lugar
                              final ocupado = lugar.estado == "RESERVADO";
                              final seleccionado =
                                  lugar == controller.lugarSeleccionado.value;
                              final color = ocupado
                                  ? Colors.red
                                  : seleccionado
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade300;

                              return GestureDetector(
                                onTap: !ocupado
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
                                      color: ocupado
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

  void _mostrarDialogoAgregarAuto(BuildContext context) {
    final chapaController = TextEditingController();
    final chasisController = TextEditingController();
    final controller = Get.find<AlumnoReservaController>();

    // Map de marcas y modelos icónicos
    const Map<String, List<String>> autosPopulares = {
      "Nissan": ["Skyline GT-R R34", "350Z", "Silvia S15"],
      "Toyota": ["Supra MK4", "AE86", "Celica GT-Four"],
      "Mazda": ["RX-7 FD", "RX-8"],
      "Mitsubishi": ["Lancer Evolution IX", "Lancer Evolution VI", "3000GT"],
      "Subaru": ["Impreza WRX STI (GD)", "BRZ"],
      "Ford": ["Mustang GT", "Focus RS"],
      "Chevrolet": ["Camaro SS", "Corvette C6"],
      "Dodge": ["Charger R/T", "Viper GTS"],
      "BMW": ["M3 GTR", "M5 E60"],
      "Porsche": ["911 GT3 RS", "Carrera GT"],
      "Volkswagen": ["Golf GTI"],
      "Honda": ["Civic Type R", "S2000"],
      "Audi": ["RS4"],
      "Lamborghini": ["Murciélago", "Gallardo"],
      "Ferrari": ["F355", "F40"],
    };
    String? marcaSeleccionada;
    String? modeloSeleccionado;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Agregar auto"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: chapaController,
                  decoration: const InputDecoration(
                    labelText: "Chapa",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: marcaSeleccionada,
                  decoration: const InputDecoration(
                    labelText: "Marca",
                    border: OutlineInputBorder(),
                  ),
                  items: autosPopulares.keys
                      .map((marca) => DropdownMenuItem(
                            value: marca,
                            child: Text(marca),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      marcaSeleccionada = value;
                      modeloSeleccionado = null;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: modeloSeleccionado,
                  decoration: const InputDecoration(
                    labelText: "Modelo",
                    border: OutlineInputBorder(),
                  ),
                  items: (marcaSeleccionada != null)
                      ? autosPopulares[marcaSeleccionada]!
                          .map((modelo) => DropdownMenuItem(
                                value: modelo,
                                child: Text(modelo),
                              ))
                          .toList()
                      : [],
                  onChanged: (value) {
                    setState(() {
                      modeloSeleccionado = value;
                    });
                  },
                  disabledHint: const Text("Selecciona una marca primero"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: chasisController,
                  decoration: const InputDecoration(
                    labelText: "Chasis",
                    border: OutlineInputBorder(),
                  ),
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
              onPressed: () async {
                if (chapaController.text.isEmpty || marcaSeleccionada == null || modeloSeleccionado == null || chasisController.text.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Completa todos los campos',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                final db = controller.db;
                final autos = await db.getAll("autos.json");
                autos.add({
                  "chapa": chapaController.text,
                  "marca": marcaSeleccionada,
                  "modelo": modeloSeleccionado,
                  "chasis": chasisController.text,
                  "clienteId": controller.codigoClienteActual
                });
                await db.saveAll("autos.json", autos);
                await controller.cargarAutosDelCliente();
                Navigator.pop(context);
                Get.snackbar(
                  'Éxito',
                  'Auto agregado correctamente',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
} 