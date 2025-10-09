// school_class_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sms/entity/school_class.dart';


class SchoolClassService {
  final String baseUrl = 'http://localhost:8080/api/schoolclass'; // Update as needed

  Future<List<SchoolClass>> getAllClasses() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => SchoolClass.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load classes');
    }
  }

  Future<SchoolClass> createClass(String name) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SchoolClass.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create class');
    }
  }

  Future<void> deleteClass(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete class');
    }
  }
}
