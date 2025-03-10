class CheckEmailRequest {
  final String email;

  CheckEmailRequest({
    required this.email,
  });

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class CheckEmailResponse {
  final String status;

  CheckEmailResponse({
    required this.status,
  });

  factory CheckEmailResponse.fromJson(Map<String, dynamic> json) {
    return CheckEmailResponse(
      status: json['message'],
    );
  }
}
