// payment_dto.dart
class PaymentDTO {
  final String studentName;
  final String schoolClass;
  final String section;
  final String month;
  final String category;
  final double amount;
  final bool paid;
  final String paymentDate;  // as string

  PaymentDTO({
    required this.studentName,
    required this.schoolClass,
    required this.section,
    required this.month,
    required this.category,
    required this.amount,
    required this.paid,
    required this.paymentDate,
  });

  factory PaymentDTO.fromJson(Map<String, dynamic> json) {
    return PaymentDTO(
      studentName: json['studentName'],
      schoolClass: json['schoolClass'],
      section: json['section'],
      month: json['month'],
      category: json['category'],
      amount: (json['amount'] as num).toDouble(),
      paid: json['paid'],
      paymentDate: json['paymentDate'],
    );
  }
}
