import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sms/dto/payment_dto.dart';
import 'package:sms/entity/payment.dart';


class PaymentService {
  final String baseUrl = 'http://localhost:8080/api/payment'; // Change to your API base

  Future<List<Payment>> getAllPayments() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Payment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load payments');
    }
  }

  Future<Payment> getPaymentById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Payment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get payment');
    }
  }

  Future<Payment> createPayment(Payment payment) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payment.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Payment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create payment');
    }
  }

  Future<Payment> updatePayment(int id, Payment payment) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payment.toJson()),
    );
    if (response.statusCode == 200) {
      return Payment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update payment');
    }
  }

  Future<void> deletePayment(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete payment');
    }
  }

  Future<List<PaymentDTO>> getPaymentsByStudentId(int studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/student/$studentId'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => PaymentDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load payment DTOs');
    }
  }
}
