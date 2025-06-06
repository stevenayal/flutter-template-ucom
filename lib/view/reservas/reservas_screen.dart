import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finpay/controller/reserva_controller.dart';
import 'package:finpay/model/sitema_reservas.dart';
import 'package:finpay/utils/utiles.dart';
import '../../alumno/config/app_theme.dart' as theme;
import '../../alumno/config/textstyle.dart' as text;
import '../../alumno/widgets/custom_button.dart';

class ReservaScreen extends StatelessWidget {
  final controller = Get.put(ReservaController());

  ReservaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reservar lugar")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(theme.AppTheme.spacing),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Seleccionar auto",
                    style: text.AppTextStyle.textStyle16w600),
                Obx(() {
                  return DropdownButton<Auto>(
                    isExpanded: true,
                    value: controller.autoSeleccionado.value,
                    hint: Text("Seleccionar auto"),
                    onChanged: (auto) {
                      controller.autoSeleccionado.value = auto;
                    },
                    items: controller.autosCliente.map((a) {
                      final nombre = "${a.chapa} - ${a.marca} ${a.modelo}";
                      return DropdownMenuItem(value: a, child: Text(nombre));
                    }).toList(),
                  );
                }),
                SizedBox(height: theme.AppTheme.spacing),
                Text("Seleccionar piso",
                    style: text.AppTextStyle.textStyle16w600),
                DropdownButton<Piso>(
                  isExpanded: true,
                  value: controller.pisoSeleccionado.value,
                  hint: Text("Seleccionar piso"),
                  onChanged: (p) => controller.seleccionarPiso(p!),
                  items: controller.pisos
                      .map((p) => DropdownMenuItem(
                          value: p, child: Text(p.descripcion)))
                      .toList(),
                ),
                SizedBox(height: theme.AppTheme.spacing),
                Text("Seleccionar lugar",
                    style: text.AppTextStyle.textStyle16w600),
                SizedBox(height: theme.AppTheme.smallSpacing),
                SizedBox(
                  height: 200,
                  child: GridView.count(
                    crossAxisCount: 5,
                    crossAxisSpacing: theme.AppTheme.smallSpacing,
                    mainAxisSpacing: theme.AppTheme.smallSpacing,
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
                              ? theme.AppTheme.primaryColor
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
                                    ? theme.AppTheme.primaryColor
                                    : Colors.black12),
                            borderRadius: BorderRadius.circular(theme.AppTheme.borderRadius),
                          ),
                          child: Text(
                            lugar.codigoLugar,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: lugar.estado == "reservado"
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: theme.AppTheme.spacing),
                Text("Seleccionar horarios",
                    style: text.AppTextStyle.textStyle16w600),
                SizedBox(height: theme.AppTheme.smallSpacing),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
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
                    SizedBox(width: theme.AppTheme.smallSpacing),
                    Expanded(
                      child: ElevatedButton.icon(
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
                SizedBox(height: theme.AppTheme.spacing),
                Text("Duración rápida",
                    style: text.AppTextStyle.textStyle16w600),
                SizedBox(height: theme.AppTheme.smallSpacing),
                Wrap(
                  spacing: theme.AppTheme.smallSpacing,
                  runSpacing: theme.AppTheme.smallSpacing,
                  children: [1, 2, 4, 6, 8].map((horas) {
                    final seleccionada =
                        controller.duracionSeleccionada.value == horas;
                    return ChoiceChip(
                      label: Text("$horas h"),
                      selected: seleccionada,
                      selectedColor: theme.AppTheme.primaryColor,
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
                Obx(() {
                  final inicio = controller.horarioInicio.value;
                  final salida = controller.horarioSalida.value;

                  if (inicio == null || salida == null) return SizedBox.shrink();

                  final minutos = salida.difference(inicio).inMinutes;
                  final horas = minutos / 60;
                  final monto = (horas * 10000).round();

                  return Padding(
                    padding: EdgeInsets.only(
                        top: theme.AppTheme.spacing,
                        bottom: theme.AppTheme.smallSpacing),
                    child: Text(
                      "Monto estimado: ₲${UtilesApp.formatearGuaranies(monto)}",
                      style: text.AppTextStyle.textStyle16w600.copyWith(
                        color: theme.AppTheme.primaryColor,
                      ),
                    ),
                  );
                }),
                SizedBox(height: theme.AppTheme.largeSpacing),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    buttonText: "Confirmar Reserva",
                    onPressed: () async {
                      final confirmada = await controller.confirmarReserva();

                      if (confirmada) {
                        Get.snackbar(
                          "Reserva",
                          "Reserva realizada con éxito",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: theme.AppTheme.primaryColor,
                          colorText: Colors.white,
                        );

                        await Future.delayed(const Duration(milliseconds: 2000));
                        Get.back();
                      } else {
                        Get.snackbar(
                          "Error",
                          "Verificá que todos los campos estén completos",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: theme.AppTheme.errorColor,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
