class SearchTripsRequest {
  final String userId;
  final String departureLocation;
  final String destinationLocation;
  final DateTime? departureDate;
  final int? maxDistance;

  SearchTripsRequest({
    required this.userId,
    required this.departureLocation,
    required this.destinationLocation,
    this.departureDate,
    this.maxDistance,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'departureLocation': departureLocation,
      'destinationLocation': destinationLocation,
      'departureDate': departureDate?.toIso8601String(),
      'maxDistance': maxDistance,
    };
  }
}
