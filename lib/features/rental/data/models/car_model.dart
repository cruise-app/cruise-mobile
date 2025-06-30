class CarModel {
  final String id; // Added for _id
  final String plateNumber;
  final String name;
  final String category;
  final String imagePath; // Maps to imageUrl
  final int pricePerDay; // Maps to dailyRate
  final int totalPrice; // Optional, as it may be calculated
  final String transmission;
  final String description;
  final String location; // Stringified GeoJSON coordinates
  final double rating;
  final String ownerId; // Added for ownerId
  final bool isNegotiable; // Added for isNegotiable
  final String insuranceTerms; // Added for insuranceTerms
  final bool isAvailable; // Added for isAvailable
  final List<String> features; // Added for features
  final String fuelType; // Added for fuelType
  final int? year; // Added for year, nullable
  final int totalRentals; // Added for totalRentals
  final DateTime createdAt; // Added for createdAt
  final DateTime updatedAt; // Added for updatedAt

  CarModel({
    this.id = '',
    required this.plateNumber,
    required this.name,
    this.category = 'Standard',
    this.imagePath = 'https://picsum.photos/800/400',
    required this.pricePerDay,
    required this.totalPrice,
    this.transmission = 'Automatic',
    this.description = 'Car description not available',
    this.location = 'Location not specified',
    this.rating = 4.5,
    this.ownerId = '',
    this.isNegotiable = false,
    this.insuranceTerms = 'Standard insurance terms apply',
    this.isAvailable = true,
    this.features = const [],
    this.fuelType = 'Petrol',
    this.year,
    this.totalRentals = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['_id'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      name: json['model'] ?? 'Unknown',
      category: json['category'] ?? 'Standard',
      imagePath: json['imageUrl'] ?? 'https://picsum.photos/800/400',
      pricePerDay: (json['dailyRate'] ?? 0).toInt(),
      totalPrice: (json['totalPrice'] ?? json['dailyRate'] ?? 0).toInt(),
      transmission: json['transmission'] ?? 'Automatic',
      description: json['description'] ??
          '3rd Category - 20,550 KM - Automatic - 2000CC - Yellow - License Valid to 30 / 06 / 2026',
      location: _stringifyLocation(json['location']),
      rating: (json['rating'] ?? 4.5).toDouble(),
      ownerId: json['ownerId'] ?? '',
      isNegotiable: json['isNegotiable'] ?? false,
      insuranceTerms: json['insuranceTerms'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      features: List<String>.from(json['features'] ?? []),
      fuelType: json['fuelType'] ?? 'Petrol',
      year: json['year'] != null ? json['year'].toInt() : null,
      totalRentals: (json['totalRentals'] ?? 0).toInt(),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'plateNumber': plateNumber,
        'model': name,
        'category': category,
        'imageUrl': imagePath,
        'dailyRate': pricePerDay,
        'totalPrice': totalPrice,
        'transmission': transmission,
        'description': description,
        'location': location,
        'rating': rating,
        'ownerId': ownerId,
        'isNegotiable': isNegotiable,
        'insuranceTerms': insuranceTerms,
        'isAvailable': isAvailable,
        'features': features,
        'fuelType': fuelType,
        'year': year,
        'totalRentals': totalRentals,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Converts a GeoJSON `location` object (or any Map) to a readable string.
  static String _stringifyLocation(dynamic locationField) {
    if (locationField is Map &&
        locationField.containsKey('coordinates') &&
        locationField['coordinates'] is List) {
      final coordinates = locationField['coordinates'] as List;
      if (coordinates.length >= 2) {
        return "${coordinates[1]}, ${coordinates[0]}"; // [longitude, latitude] to "latitude, longitude"
      }
    }
    // Fallback for invalid or missing location
    return locationField?.toString() ?? 'Unknown';
  }
}
