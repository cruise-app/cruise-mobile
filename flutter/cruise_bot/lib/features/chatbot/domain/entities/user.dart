import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final Map<String, dynamic> preferences;
  
  const User({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.preferences,
  });
  
  @override
  List<Object?> get props => [id, name, avatarUrl, preferences];
}
