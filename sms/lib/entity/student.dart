// student.dart
import 'user.dart';
import 'section.dart';
import 'school_class.dart';

class Students {
  int? id;
  String? name;
  String? email;
  String? photo;
  User? user;
  Section? section;
  SchoolClass? schoolClass;

  Students({
    this.id,
    this.name,
    this.email,
    this.photo,
    this.user,
    this.section,
    this.schoolClass,
  });

  factory Students.fromJson(Map<String, dynamic> json) {
    return Students(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      user: (json['user'] != null && json['user'] is Map<String, dynamic>)
          ? User.fromJson(json['user'])
          : null,
      section: (json['section'] != null && json['section'] is Map<String, dynamic>)
          ? Section.fromJson(json['section'])
          : null,
      schoolClass: (json['schoolClass'] != null && json['schoolClass'] is Map<String, dynamic>)
          ? SchoolClass.fromJson(json['schoolClass'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['photo'] = photo;
    if (user != null) data['user'] = user!.toJson();
    if (section != null) data['section'] = section!.toJson();
    if (schoolClass != null) data['schoolClass'] = schoolClass!.toJson();
    return data;
  }
}
