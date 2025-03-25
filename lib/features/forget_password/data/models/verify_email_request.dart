class VerifyEmailRequest {
  final String email;

  VerifyEmailRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
