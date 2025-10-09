// section_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sms/entity/section.dart';


class SectionService {
  final String baseUrl = 'http://localhost:8080/api/sections'; // adjust as needed

  Future<List<Section>> getAllSections() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Section.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sections');
    }
  }

  Future<Section> getSectionById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Section.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get section');
    }
  }

  Future<Section> createSection(Section section) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(section.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Section.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create section');
    }
  }

  Future<Section> updateSection(int id, Section section) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(section.toJson()),
    );
    if (response.statusCode == 200) {
      return Section.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update section');
    }
  }

  Future<void> deleteSection(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete section');
    }
  }
}
