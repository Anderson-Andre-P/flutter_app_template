import '../domain/entities/user.dart';

/// JSON mapping of [User] (hand-written, no code generation).
abstract final class UserModel {
  static Map<String, dynamic> toJson(User user) => {
    'id': user.id,
    'name': user.name,
    'email': user.email,
  };

  static User fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
  );
}
