// Archivo del alumno
// Este archivo es parte del trabajo realizado por el alumno y puede contener modificaciones.

class CarData {
  final String brand;
  final String model;
  final String licensePlate;
  final int year;
  final String color;
  final String? observations;

  CarData({
    required this.brand,
    required this.model,
    required this.licensePlate,
    required this.year,
    required this.color,
    this.observations,
  });

  @override
  String toString() {
    return 'CarData(brand: $brand, model: $model, licensePlate: $licensePlate, year: $year, color: $color, observations: $observations)';
  }

  // Métodos opcionales como toJson/fromJson si son necesarios
} 