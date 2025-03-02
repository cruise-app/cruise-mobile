class RegisterResponse {
  final String message;
  final String userId;

  RegisterResponse({
    required this.message,
    required this.userId,
  });

  // Factory constructor to create RegisterResponse from JSON
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] ?? "No message",
      userId: json['userId'] ?? "",
    );
  }
}
