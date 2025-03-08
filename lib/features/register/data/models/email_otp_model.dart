class EmailOtpRequest {
  final String email;

  EmailOtpRequest({
    required this.email,
  });

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class EmailOtpResponse {
  final String status;

  EmailOtpResponse({
    required this.status,
  });

  factory EmailOtpResponse.fromJson(Map<String, dynamic> json) {
    return EmailOtpResponse(
      status: json['message'],
    );
  }
}
