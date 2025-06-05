class CreateTripRequest {
  final String? driverID;
  final String? driverUsername;
  final String? startLocationName;
  final String? endLocationName;
  final String? departureTime;
  final String? vehicleType;

  CreateTripRequest({
    this.driverID,
    this.driverUsername,
    this.startLocationName,
    this.endLocationName,
    this.departureTime,
    this.vehicleType,
  });

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverID,
      'driverUsername': driverUsername,
      'startLocationName': startLocationName,
      'endLocationName': endLocationName,
      'departureTime': departureTime,
      'vehicleType': vehicleType,
    };
  }
}
