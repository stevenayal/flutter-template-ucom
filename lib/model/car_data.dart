class CarData {
  final String brand;
  final String model;
  final String plate;
  final String observations;

  CarData({
    required this.brand,
    required this.model,
    required this.plate,
    required this.observations,
  });

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'plate': plate,
      'observations': observations,
    };
  }

  factory CarData.fromJson(Map<String, dynamic> json) {
    return CarData(
      brand: json['brand'],
      model: json['model'],
      plate: json['plate'],
      observations: json['observations'],
    );
  }
} 