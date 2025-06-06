import 'package:equatable/equatable.dart';

enum CarType {
  standard,
  comfort,
  luxury,
  suv
}

class Car extends Equatable {
  final String id;
  final String model;
  final String plateNumber;
  final CarType type;
  final String imageUrl;
  final double price;
  final int estimatedTimeMin;
  
  const Car({
    required this.id,
    required this.model,
    required this.plateNumber,
    required this.type,
    required this.imageUrl,
    required this.price,
    required this.estimatedTimeMin,
  });
  
  @override
  List<Object> get props => [id, model, plateNumber, type, imageUrl, price, estimatedTimeMin];
}
