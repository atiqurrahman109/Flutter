

import 'package:sms/entity/payment.dart';
import 'package:sms/entity/result.dart';

import 'user.dart';
import 'section.dart';
import 'school_class.dart';

class Student {
  final int id;
  final String name;
  final String email;
  final String photo;
  final User user;
  final Section section;
  final List<Payment> payments;
  final List<Result> results;
  final SchoolClass schoolClass;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
    required this.user,
    required this.section,
    required this.payments,
    required this.results,
    required this.schoolClass,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      user: User.fromJson(json['user']),
      section: Section.fromJson(json['section']),
      payments: (json['payments'] as List)
          .map((p) => Payment.fromJson(p))
          .toList(),
      results: (json['results'] as List)
          .map((r) => Result.fromJson(r))
          .toList(),
      schoolClass: SchoolClass.fromJson(json['schoolClass']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}