class CreatePasswordResponse {
  final String message;
  final bool success;

  CreatePasswordResponse({required this.message, required this.success});

  factory CreatePasswordResponse.fromJson(Map<String, dynamic> json) {
    return CreatePasswordResponse(
      message: json['message'],
      success: json['success'],
    );
  }
}
