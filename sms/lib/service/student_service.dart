// student_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sms/entity/student.dart';


class StudentService {
  final String baseUrl = 'http://localhost:8080/api/students'; // Adjust if needed

  Future<List<Student>> getAllStudents() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((data) => Student.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<void> deleteStudent(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete student');
    }
  }
}
