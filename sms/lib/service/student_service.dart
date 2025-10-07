
import 'package:http/http.dart' as http;
import 'package:sms/entity/student.dart';
import 'dart:convert';

import 'package:sms/service/authservice.dart';



class StudentService{

  final String baseUrl = "http://localhost:8080/api/students";


  Future<Student?> fetchStudentProfile(int id) async {
    final url = Uri.parse("$baseUrl/profile/$id");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Student.fromJson(data);
    } else {
      print("Profile fetch failed: ${response.body}");
      return null;
    }
  }



}