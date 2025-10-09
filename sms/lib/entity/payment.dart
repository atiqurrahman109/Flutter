// payment.dart
import 'student.dart';

class Payment {
  final int id;
  final String month;
  final String category;
  final double amount;
  final bool paid;
  final DateTime paymentDate;
  final Student student;

  Payment({
    required this.id,
    required this.month,
    required this.category,
    required this.amount,
    required this.paid,
    required this.paymentDate,
    required this.student,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      month: json['month'],
      category: json['category'],
      amount: (json['amount'] as num).toDouble(),
      paid: json['paid'],
      paymentDate: DateTime.parse(json['paymentDate']),
      student: Student.fromJson(json['student']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'month': month,
      'category': category,
      'amount': amount,
      'paid': paid,
      'paymentDate': paymentDate.toIso8601String(),
      'student': student.toJson(),
    };
  }
}
