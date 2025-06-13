// ignore_for_file: deprecated_member_use

import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/home_controller.dart';
import 'package:finpay/utils/utiles.dart';
import 'package:finpay/view/home/widget/transaction_list.dart';
import 'package:finpay/view/statistics/widget/card_view.dart';
import 'package:finpay/view/statistics/widget/circle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  final homeController = Get.put(HomeController());
  @override
  void initState() {
    homeController.customInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: AppTheme.isLightTheme == false
          ? HexColor('#15141f')
          : HexColor(AppTheme.primaryColorString!).withOpacity(0.05),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                      ),
                      Text(
                        "Estadísticas de Estacionamiento",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Resumen del Mes",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .color!
                                  .withOpacity(0.60),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Obx(() => Text(
                                "${homeController.reservasMesActual.value} reservas",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                    ),
                              )),
                          const SizedBox(width: 10),
                          Text(
                            "este mes",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .color!
                                      .withOpacity(0.60),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Tarjetas de estadísticas de estacionamiento
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => _buildStatCard(
                              context,
                              "Reservas Pendientes",
                              homeController.reservasPendientes.value.toString(),
                              Icons.pending_actions,
                              Colors.orange,
                            )),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => _buildStatCard(
                              context,
                              "Reservas Completadas",
                              homeController.reservasCompletadas.value.toString(),
                              Icons.check_circle_outline,
                              Colors.green,
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => _buildStatCard(
                              context,
                              "Reservas Canceladas",
                              homeController.reservasCanceladas.value.toString(),
                              Icons.cancel_outlined,
                              Colors.red,
                            )),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => _buildStatCard(
                              context,
                              "Autos Registrados",
                              homeController.cantidadAutos.value.toString(),
                              Icons.directions_car,
                              Colors.blue,
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => _buildStatCard(
                              context,
                              "Monto Total Mes",
                              UtilesApp.formatearGuaranies(homeController.montoTotalMes.value),
                              Icons.payments_outlined,
                              Colors.purple,
                            )),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => _buildStatCard(
                              context,
                              "Monto Pendiente",
                              UtilesApp.formatearGuaranies(homeController.montoPendiente.value),
                              Icons.pending_outlined,
                              Colors.amber,
                            )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Selector de período
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      cardView(
                        context,
                        homeController.isWeek.value == true
                            ? HexColor(AppTheme.primaryColorString!)
                            : AppTheme.isLightTheme == false
                                ? const Color(0xff211F32)
                                : const Color(0xffF9F9FA),
                        homeController.isWeek.value == true
                            ? Colors.white
                            : const Color(0xffA2A0A8),
                        () {
                          setState(() {
                            homeController.isWeek.value = true;
                            homeController.isMonth.value = false;
                            homeController.isYear.value = false;
                          });
                        },
                        "Semana",
                      ),
                      cardView(
                        context,
                        homeController.isMonth.value == true
                            ? HexColor('#6C56F9')
                            : AppTheme.isLightTheme == false
                                ? const Color(0xff211F32)
                                : const Color(0xffF9F9FA),
                        homeController.isMonth.value == true
                            ? Colors.white
                            : const Color(0xffA2A0A8),
                        () {
                          setState(() {
                            homeController.isWeek.value = false;
                            homeController.isMonth.value = true;
                            homeController.isYear.value = false;
                          });
                        },
                        "Mes",
                      ),
                      cardView(
                        context,
                        homeController.isYear.value == true
                            ? HexColor(AppTheme.primaryColorString!)
                            : AppTheme.isLightTheme == false
                                ? const Color(0xff211F32)
                                : const Color(0xffF9F9FA),
                        homeController.isYear.value == true
                            ? Colors.white
                            : const Color(0xffA2A0A8),
                        () {
                          setState(() {
                            homeController.isWeek.value = false;
                            homeController.isMonth.value = false;
                            homeController.isYear.value = true;
                          });
                        },
                        "Año",
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (homeController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (homeController.hasError.value) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error al cargar los datos',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                homeController.lastError.value,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => homeController.retryLoading(),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        const SizedBox(height: 20),
                        // Gráfico de uso de estacionamiento reemplazado por indicador de resumen
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 180, // Altura ajustada para el nuevo indicador
                            decoration: BoxDecoration(
                              color: AppTheme.isLightTheme == false
                                  ? const Color(0xff211F32)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xff000000).withOpacity(0.10),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Resumen de Reservas Activas",
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Obx(() => Text(
                                        "${homeController.reservasMesActual.value} reservas este mes",
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                      )),
                                  const SizedBox(height: 8),
                                  Obx(() => Text(
                                        "${homeController.cantidadAutos.value} autos registrados",
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                      )),
                                  // Puedes agregar más indicadores o lógica aquí según necesites
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Lista de movimientos recientes
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.isLightTheme == false
                                  ? const Color(0xff211F32)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xff000000).withOpacity(0.10),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        homeController.isWeek.value == true
                                            ? "Movimientos de la Semana"
                                            : homeController.isMonth.value == true
                                                ? "Movimientos del Mes"
                                                : "Movimientos del Año",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(() {
                                  if (homeController.pagosPrevios.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        "No hay movimientos registrados",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    );
                                  }
                                  return Column(
                                    children: homeController.pagosPrevios.map((pago) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: transactionList(
                                          DefaultImages.pagoIcono,
                                          HexColor(AppTheme.primaryColorString!),
                                          "Reserva: ${pago.codigoReservaAsociada}",
                                          "Fecha: ${UtilesApp.formatearFechaDdMMAaaa(pago.fechaPago)}",
                                          "- ${UtilesApp.formatearGuaranies(pago.montoPagado)}",
                                          "",
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          // Indicador de carga global
          Obx(() {
            if (homeController.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2), width: 1),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar errores en secciones específicas
  Widget _buildErrorSection(String message, VoidCallback onRetry) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar estados de carga en secciones específicas
  Widget _buildLoadingSection() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Widget para mostrar mensaje cuando no hay datos
  Widget _buildEmptySection(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, color: Colors.grey, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
