class VerifyEmailResponse {
  final String message;
  final bool success;
  VerifyEmailResponse({required this.message, required this.success});

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponse(
      message: json['message'],
      success: json['success'],
    );
  }
}
