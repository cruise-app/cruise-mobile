class GetPolylineRequest {
  final String startLocationName;
  final String endLocationName;

  GetPolylineRequest({
    required this.startLocationName,
    required this.endLocationName,
  });

  Map<String, dynamic> toJson() {
    return {
      'startLocationName': startLocationName,
      'endLocationName': endLocationName,
    };
  }
}
