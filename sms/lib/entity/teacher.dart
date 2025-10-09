// teacher.dart
import 'user.dart';

class Teacher {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final User user;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.user,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photo: json['photo'],
      user: User.fromJson(json['user']),
    );
  }
}
