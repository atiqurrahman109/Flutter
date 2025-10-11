// user.dart
class User {
  int? id;
  String? username;
  String? email;
  String? photo;
  String? password;
  String? role;

  User({
    this.id,
    this.username,
    this.email,
    this.photo,
    this.password,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      photo: json['photo'],
      password: json['password'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'photo': photo,
      'password': password,
      'role': role,
    };
  }
}
