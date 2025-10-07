import 'package:sms/entity/student.dart';

class Payment {
  int id;
  Student student;
  String month;
  String category;
  int amount;
  bool paid;
  DateTime paymentDate;

  Payment({
    required this.id,
    required this.student,
    required this.month,
    required this.category,
    required this.amount,
    required this.paid,
    required this.paymentDate,
  });

}

