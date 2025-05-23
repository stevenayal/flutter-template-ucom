// Archivo del alumno
// Este archivo es parte del trabajo realizado por el alumno y puede contener modificaciones.

import 'package:get/get.dart';
import '../model/sistema_reservas.dart';
import '../api/local.db.service.dart';

class AlumnoReservaController extends GetxController {
  final autoSeleccionado = Rxn<Auto>();
  final pisoSeleccionado = Rxn<Piso>();
  final lugarSeleccionado = Rxn<Lugar>();
  final horarioInicio = Rxn<DateTime>();
  final horarioSalida = Rxn<DateTime>();
  final duracionSeleccionada = 0.obs;
  final isLoading = false.obs;

  // Datos de ejemplo
  final autosCliente = <Auto>[
    Auto(
      chapa: 'TTEGTR',
      marca: 'Nissan',
      modelo: 'Skyline GT-R R34',
      chasis: 'BNR34',
      clienteId: 'cliente_1',
    ),
    Auto(
      chapa: '2JZSUP',
      marca: 'Toyota',
      modelo: 'Supra MK4',
      chasis: 'JZA80',
      clienteId: 'cliente_1',
    ),
    Auto(
      chapa: 'RX7FD',
      marca: 'Mazda',
      modelo: 'RX-7 FD',
      chasis: 'FD3S',
      clienteId: 'cliente_1',
    ),
     Auto(
      chapa: 'EVO9',
      marca: 'Mitsubishi',
      modelo: 'Lancer Evolution IX',
      chasis: 'CT9A',
      clienteId: 'cliente_1',
    ),
      Auto(
      chapa: 'GDISTI',
      marca: 'Subaru',
      modelo: 'Impreza WRX STI (GD)',
      chasis: 'GDB',
      clienteId: 'cliente_1',
    ),
  ].obs;

  final pisos = <Piso>[
    Piso(
      codigo: 'P1',
      descripcion: 'Piso 1',
      lugares: [
        Lugar(
          codigoLugar: 'A1',
          codigoPiso: 'P1',
          estado: 'DISPONIBLE',
          descripcionLugar: 'Lugar A1',
        ),
        Lugar(
          codigoLugar: 'A2',
          codigoPiso: 'P1',
          estado: 'RESERVADO',
          descripcionLugar: 'Lugar A2',
        ),
      ],
    ),
    Piso(
      codigo: 'P2',
      descripcion: 'Piso 2',
      lugares: [
        Lugar(
          codigoLugar: 'B1',
          codigoPiso: 'P2',
          estado: 'DISPONIBLE',
          descripcionLugar: 'Lugar B1',
        ),
      ],
    ),
  ].obs;

  final lugaresDisponibles = <Lugar>[
    Lugar(
      codigoLugar: 'A1',
      codigoPiso: 'P1',
      estado: 'DISPONIBLE',
      descripcionLugar: 'Lugar A1',
    ),
    Lugar(
      codigoLugar: 'A2',
      codigoPiso: 'P1',
      estado: 'RESERVADO',
      descripcionLugar: 'Lugar A2',
    ),
    Lugar(
      codigoLugar: 'B1',
      codigoPiso: 'P2',
      estado: 'DISPONIBLE',
      descripcionLugar: 'Lugar B1',
    ),
  ].obs;

  final db = LocalDBService();
  String codigoClienteActual = 'cliente_1';

  @override
  void onInit() {
    super.onInit();
    resetearCampos();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Try loading from database first
    await cargarAutosDelCliente();
    await cargarPisosYLugares();

    // If database load failed or returned empty, use example data
    if (autosCliente.isEmpty) {
       autosCliente.value = <Auto>[
        Auto(
          chapa: 'TTEGTR',
          marca: 'Nissan',
          modelo: 'Skyline GT-R R34',
          chasis: 'BNR34',
          clienteId: 'cliente_1',
        ),
        Auto(
          chapa: '2JZSUP',
          marca: 'Toyota',
          modelo: 'Supra MK4',
          chasis: 'JZA80',
          clienteId: 'cliente_1',
        ),
        Auto(
          chapa: 'RX7FD',
          marca: 'Mazda',
          modelo: 'RX-7 FD',
          chasis: 'FD3S',
          clienteId: 'cliente_1',
        ),
         Auto(
          chapa: 'EVO9',
          marca: 'Mitsubishi',
          modelo: 'Lancer Evolution IX',
          chasis: 'CT9A',
          clienteId: 'cliente_1',
        ),
          Auto(
          chapa: 'GDISTI',
          marca: 'Subaru',
          modelo: 'Impreza WRX STI (GD)',
          chasis: 'GDB',
          clienteId: 'cliente_1',
        ),
      ];
    }

    if (pisos.isEmpty) {
      pisos.value = <Piso>[
        Piso(
          codigo: 'P1',
          descripcion: 'Piso 1',
          lugares: [
            Lugar(
              codigoLugar: 'A1',
              codigoPiso: 'P1',
              estado: 'DISPONIBLE',
              descripcionLugar: 'Lugar A1',
            ),
            Lugar(
              codigoLugar: 'A2',
              codigoPiso: 'P1',
              estado: 'RESERVADO',
              descripcionLugar: 'Lugar A2',
            ),
          ],
        ),
        Piso(
          codigo: 'P2',
          descripcion: 'Piso 2',
          lugares: [
            Lugar(
              codigoLugar: 'B1',
              codigoPiso: 'P2',
              estado: 'DISPONIBLE',
              descripcionLugar: 'Lugar B1',
            ),
          ],
        ),
      ];
       // Also initialize lugaresDisponibles if pisos are empty
       lugaresDisponibles.value = pisos.expand((p) => p.lugares).toList();
    }
     // Ensure lugaresDisponibles is populated correctly based on loaded/example pisos
    if (lugaresDisponibles.isEmpty && pisos.isNotEmpty) {
         lugaresDisponibles.value = pisos.expand((p) => p.lugares).toList();
    }
  }

  void seleccionarPiso(Piso piso) {
    pisoSeleccionado.value = piso;
    lugarSeleccionado.value = null;
  }

  Future<bool> confirmarReserva() async {
    if (lugarSeleccionado.value == null ||
        horarioInicio.value == null ||
        horarioSalida.value == null ||
        autoSeleccionado.value == null) {
      return false;
    }

    isLoading.value = true;
    // Simular llamada a API
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    return true;
  }

  void resetearCampos() {
    autoSeleccionado.value = null;
    pisoSeleccionado.value = null;
    lugarSeleccionado.value = null;
    horarioInicio.value = null;
    horarioSalida.value = null;
    duracionSeleccionada.value = 0;
  }

  Future<void> cargarAutosDelCliente() async {
    final rawAutos = await db.getAll("autos.json");
    final autos = rawAutos.map((e) => Auto.fromJson(e)).toList();

    autosCliente.value =
        autos.where((a) => a.clienteId == codigoClienteActual).toList();
  }

  Future<void> cargarPisosYLugares() async {
    final rawPisos = await db.getAll("pisos.json");
    final rawLugares = await db.getAll("lugares.json");
    final rawReservas = await db.getAll("reservas.json");

    final reservas = rawReservas.map((e) => Reserva.fromJson(e)).toList();
    final lugaresReservados = reservas.map((r) => r.codigoReserva).toSet();

    final todosLugares = rawLugares.map((e) => Lugar.fromJson(e)).toList();

    // Unir pisos con sus lugares correspondientes
    pisos.value = rawPisos.map((pJson) {
      final codigoPiso = pJson['codigo'];
      final lugaresDelPiso =
          todosLugares.where((l) => l.codigoPiso == codigoPiso).toList();

      return Piso(
        codigo: codigoPiso,
        descripcion: pJson['descripcion'],
        lugares: lugaresDelPiso,
      );
    }).toList();

    // Inicializar lugares disponibles (solo los no reservados)
    lugaresDisponibles.value = todosLugares.where((l) {
      return !lugaresReservados.contains(l.codigoLugar);
    }).toList();
  }

  @override
  void onClose() {
    resetearCampos();
    super.onClose();
  }
} 