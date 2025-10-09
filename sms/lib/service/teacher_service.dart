// teacher_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sms/entity/teacher.dart';


class TeacherService {
  final String baseUrl = 'http://localhost:8080/api/teachers'; // Change if needed

  Future<List<Teacher>> getAllTeachers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Teacher.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load teachers');
    }
  }

  Future<void> deleteTeacher(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete teacher');
    }
  }
}
