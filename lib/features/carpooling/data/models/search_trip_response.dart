import 'package:cruise/features/carpooling/data/models/trip_model.dart';

class SearchTripResponse {
  final String message;
  final bool success;
  final List<Trip> trips;

  SearchTripResponse({
    required this.message,
    required this.success,
    required this.trips,
  });

  factory SearchTripResponse.fromJson(Map<String, dynamic> json) {
    print('Parsing SearchTripResponse JSON: $json');
    return SearchTripResponse(
      trips: (json['data'] as List? ?? []).map((item) {
        // Combine trip fields with closest points
        final tripJson = {
          ...(item['trip'] as Map<String, dynamic>),
          'closestPickupPoint': item['closestPickupPoint'],
          'closestDropoffPoint': item['closestDropoffPoint'],
          'pickupPolyline': item['pickupPolyline'],
          'dropoffPolyline': item['dropoffPolyline'],
        };
        return Trip.fromJson(tripJson);
      }).toList(),
      message: json['message'] ?? 'No message provided',
      success: json['success'] ?? false,
    );
  }
}
