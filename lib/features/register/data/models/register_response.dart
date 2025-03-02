class RegisterResponse {
  final String message;
  final int userId;

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
