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

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'licensePlate': licensePlate,
      'year': year,
      'color': color,
      'observations': observations,
    };
  }

  factory CarData.fromJson(Map<String, dynamic> json) {
    return CarData(
      brand: json['brand'],
      model: json['model'],
      licensePlate: json['licensePlate'],
      year: json['year'],
      color: json['color'],
      observations: json['observations'],
    );
  }
} 