class RegisterRequest {
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;
  final String email;
  final String phoneNumber;
  final String gender;
  final String month;
  final String day;
  final String year;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.month,
    required this.day,
    required this.year,
  });

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'confirmPassword': confirmPassword,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'month': month,
      'day': day,
      'year': year,
    };
  }
}
