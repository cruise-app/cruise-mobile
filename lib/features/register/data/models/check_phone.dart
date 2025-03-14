class CheckPhoneRequest {
  final String phoneNumber;

  CheckPhoneRequest({
    required this.phoneNumber,
  });

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
    };
  }
}

class CheckPhoneResponse {
  final String status;

  CheckPhoneResponse({
    required this.status,
  });

  factory CheckPhoneResponse.fromJson(Map<String, dynamic> json) {
    return CheckPhoneResponse(
      status: json['message'],
    );
  }
}
