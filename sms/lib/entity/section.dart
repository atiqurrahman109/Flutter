// section.dart
import 'school_class.dart';

class Section {
  final int id;
  final String name;
  final SchoolClass schoolClass;

  Section({
    required this.id,
    required this.name,
    required this.schoolClass,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      schoolClass: SchoolClass.fromJson(json['schoolClass']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // Note: depending on backend, you might need to send only class id
      'schoolClass': schoolClass.toJson(),
    };
  }
}
