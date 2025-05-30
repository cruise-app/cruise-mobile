import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String name,
    String? avatarUrl,
    required Map<String, dynamic> preferences,
  }) : super(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          preferences: preferences,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      preferences: json['preferences'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'preferences': preferences,
    };
  }
}
