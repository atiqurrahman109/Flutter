import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sms/entity/result.dart';


class ResultService {
  final String baseUrl = 'http://localhost:8080/api/result'; // Update to match your backend URL

  Future<List<Result>> getAllResults() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Result.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load results');
    }
  }

  Future<Result> getResultById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Result.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load result');
    }
  }

  Future<Result> createResult(Result result) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(result.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Result.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create result');
    }
  }

  Future<Result> updateResult(int id, Result result) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(result.toJson()),
    );
    if (response.statusCode == 200) {
      return Result.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update result');
    }
  }

  Future<void> deleteResult(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete result');
    }
  }
}
