import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sms/entity/student.dart';


class StudentService {
  // Replace localhost with proper IP
  final String baseUrl = 'http://localhost:8080/api/students';
  // if on real device, use your computer's LAN IP, e.g. 'http://192.168.X.Y:8080/api/students'

  Future<List<Students>> getAllStudents() async {
    final response = await http.get(Uri.parse(baseUrl));

    print("Request to $baseUrl, status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .where((e) => e != null)
          .map((e) => Students.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch students, status: ${response.statusCode}');
    }
  }

  Future<void> deleteStudent(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete student: status ${response.statusCode}');
    }
  }
}
