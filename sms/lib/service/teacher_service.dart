// teacher_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sms/entity/teacher.dart';


class TeacherService {
  final String baseUrl = 'http://localhost:8080/api/teachers'; // Change if needed

  Future<List<Teacher>> getAllTeachers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((item) => Teacher.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load teachers. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception occurred while fetching teachers: $e");
      throw Exception('Error fetching teachers: $e');
    }
  }


  Future<void> deleteTeacher(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete teacher');
    }
  }
}
