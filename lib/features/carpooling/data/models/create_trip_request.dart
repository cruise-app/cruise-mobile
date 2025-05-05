class CreateTripRequest {
  final String? driverID;
  final String? startLocationName;
  final String? endLocationName;
  final String? departureTime;
  final String? vehicleType;

  CreateTripRequest({
    this.driverID,
    this.startLocationName,
    this.endLocationName,
    this.departureTime,
    this.vehicleType,
  });

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverID,
      'startLocationName': startLocationName,
      'endLocationName': endLocationName,
      'departureTime': departureTime,
      'vehicleType': vehicleType,
    };
  }
}
