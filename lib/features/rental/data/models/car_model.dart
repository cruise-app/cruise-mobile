class CarModel {
  final String plateNumber;
  final String name;
  final String category;
  final String imagePath; // local asset for now
  final int pricePerDay;
  final int totalPrice;
  final String transmission;
  final String description;
  final String location;

  /// Average user rating out of 5.0
  final double rating;

  const CarModel({
    required this.plateNumber,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.pricePerDay,
    required this.totalPrice,
    required this.transmission,
    this.description =
        '3rd Category - 20,550 KM - Automatic - 2000CC - Yellow - License Valid to 30 / 06 / 2026',
    this.location = 'Cairo Festival City, New Cairo, Egypt',
    this.rating = 4.8,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      plateNumber: json['plateNumber'] ?? '',
      name: json['model'] ?? json['name'] ?? 'Unknown',
      category: json['category'] ?? 'Standard',
      imagePath: json['imageUrl'] ??
          'https://images.unsplash.com/photo-1549923746-c502d488b3ea?auto=format&fit=crop&w=800&q=80',
      pricePerDay: (json['dailyRate'] ?? json['pricePerDay'] ?? 0).toInt(),
      totalPrice: (json['totalPrice'] ?? json['dailyRate'] ?? 0).toInt(),
      transmission: json['transmission'] ?? 'Automatic',
      description: json['description'] ?? '',
      location: json['locationName'] ?? _stringifyLocation(json['location']),
      rating: (json['rating'] ?? 4.5).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'plateNumber': plateNumber,
        'name': name,
        'category': category,
        'imageUrl': imagePath,
        'dailyRate': pricePerDay,
        'totalPrice': totalPrice,
        'transmission': transmission,
        'description': description,
        'location': location,
        'rating': rating,
      };

  /// Converts a `{lat, lng}` object (or any Map) to a readable string.
  static String _stringifyLocation(dynamic locationField) {
    if (locationField is Map && locationField.containsKey('lat') && locationField.containsKey('lng')) {
      return "${locationField['lat']}, ${locationField['lng']}";
    }
    // If the field is already a String or null, default casting
    return locationField?.toString() ?? '';
  }
} 