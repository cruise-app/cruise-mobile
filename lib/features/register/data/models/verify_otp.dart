class VerifyOtpRequest {
  final String toVerify;
  final String otp;
  VerifyOtpRequest({required this.toVerify, required this.otp});

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'toVerify': toVerify,
      'otp': otp,
    };
  }
}

class VerifyOtpResponse {
  final String status;

  VerifyOtpResponse({
    required this.status,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      status: json['message'],
    );
  }
}
