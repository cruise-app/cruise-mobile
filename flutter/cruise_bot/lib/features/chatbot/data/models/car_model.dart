import '../../domain/entities/car.dart';

class CarModel extends Car {
  const CarModel({
    required String id,
    required String model,
    required String plateNumber,
    required CarType type,
    required String imageUrl,
    required double price,
    required int estimatedTimeMin,
  }) : super(
          id: id,
          model: model,
          plateNumber: plateNumber,
          type: type,
          imageUrl: imageUrl,
          price: price,
          estimatedTimeMin: estimatedTimeMin,
        );

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      model: json['model'],
      plateNumber: json['plateNumber'],
      type: _mapCarType(json['type']),
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      estimatedTimeMin: json['estimatedTimeMin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'plateNumber': plateNumber,
      'type': type.toString().split('.').last,
      'imageUrl': imageUrl,
      'price': price,
      'estimatedTimeMin': estimatedTimeMin,
    };
  }

  static CarType _mapCarType(String? type) {
    switch (type) {
      case 'standard':
        return CarType.standard;
      case 'comfort':
        return CarType.comfort;
      case 'luxury':
        return CarType.luxury;
      case 'suv':
        return CarType.suv;
      default:
        return CarType.standard;
    }
  }
}
