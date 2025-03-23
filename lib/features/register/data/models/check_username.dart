class CheckUsernameRequest {
  final String username;

  CheckUsernameRequest({
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': username,
    };
  }
}

class CheckUsernameResponse {
  final String message;
  final bool success;

  CheckUsernameResponse({
    required this.message,
    required this.success,
  });

  factory CheckUsernameResponse.fromJson(Map<String, dynamic> json) {
    return CheckUsernameResponse(
      message: json['message'],
      success: json['success'],
    );
  }
}
