class UserModel {
  final String id;
  final String email;
  final String userName;

  UserModel({
    required this.id,
    required this.email,
    required this.userName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      userName: json['userName'],
    );
  }
}
