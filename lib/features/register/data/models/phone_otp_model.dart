class PhoneOtpRequest {
  final String phoneNumber;

  PhoneOtpRequest({
    required this.phoneNumber,
  });

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
    };
  }
}

class PhoneOtpResponse {
  final String status;

  PhoneOtpResponse({
    required this.status,
  });

  factory PhoneOtpResponse.fromJson(Map<String, dynamic> json) {
    return PhoneOtpResponse(
      status: json['message'],
    );
  }
}
