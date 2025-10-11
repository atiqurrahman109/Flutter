import 'package:sms/entity/user.dart';

class Teacher {
  int id;
  String name;
  String? photo;
  User user;

  Teacher({
    required this.id,
    required this.name,
    this.photo,
    required this.user,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'user': user.toJson(),
    };
  }
}
