import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetPolylineResponse {
  final String? message;
  final LatLng? startLocation;
  final LatLng? endLocation;
  final String? status;
  final List<LatLng>? polyline;

  GetPolylineResponse({
    this.message,
    this.startLocation,
    this.endLocation,
    this.status,
    this.polyline,
  });

  factory GetPolylineResponse.fromJson(Map<String, dynamic> json) {
    return GetPolylineResponse(
      message: json['message'] as String?,
      startLocation: json['data']['startLocation'] != null
          ? LatLng(
              json['data']['startLocation']['latitude'] as double,
              json['data']['startLocation']['longitude'] as double,
            )
          : null,
      endLocation: json['data']['endLocation'] != null
          ? LatLng(
              json['data']['endLocation']['latitude'] as double,
              json['data']['endLocation']['longitude'] as double,
            )
          : null,
      status: json['status'] as String?,
      polyline: (json['data']['polyline'] as List)
          .map((e) => LatLng(e['latitude'], e['longitude']))
          .toList(),
    );
  }
}
