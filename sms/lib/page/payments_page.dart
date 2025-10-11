import 'package:flutter/material.dart';
import 'package:sms/dto/payment_dto.dart';
import 'package:sms/entity/payment.dart';
import 'package:sms/entity/student.dart';
import 'package:sms/service/payment_service.dart';
import 'package:sms/service/student_service.dart';

class PaymentsPage extends StatefulWidget {
  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final PaymentService _paymentService = PaymentService();
  final StudentService _studentService = StudentService();

  List<Students> _students = [];
  Students? _selectedStudent;

  List<PaymentDTO> _paymentsDto = [];
  List<Payment> _recentPayments = [];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _searchIdController = TextEditingController();

  String _selectedMonth = 'January';
  String _selectedCategory = 'Tuition Fee';

  final List<String> _months = const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _loadStudents();
    _loadRecentPayments();
  }

  void _loadStudents() async {
    try {
      var students = await _studentService.getAllStudents();
      setState(() {
        _students = students;
      });
    } catch (e) {
      _showError('Failed to load students');
    }
  }

  void _loadRecentPayments() async {
    try {
      var payments = await _paymentService.getAllPayments();
      setState(() {
        _recentPayments = payments;
      });
    } catch (e) {
      _showError('Failed to load recent payments');
    }
  }

  void _submitPayment() async {
    if (_selectedStudent == null || _amountController.text.isEmpty || _dateController.text.isEmpty) {
      _showError('Please fill all fields');
      return;
    }

    final double? amt = double.tryParse(_amountController.text);
    if (amt == null) {
      _showError('Invalid amount');
      return;
    }

    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(_dateController.text);
    } catch (_) {
      _showError('Invalid date format. Use YYYY-MM-DD.');
      return;
    }

    final payment = Payment(
      id: 0,
      month: _selectedMonth,
      category: _selectedCategory,
      amount: amt,
      paid: true,
      paymentDate: parsedDate,
      student: _selectedStudent!,
    );

    try {
      await _paymentService.createPayment(payment);
      _showMessage('Payment recorded successfully');
      _amountController.clear();
      _dateController.clear();
      _loadRecentPayments();
    } catch (_) {
      _showError('Failed to record payment');
    }
  }

  void _searchStudentPayments() {
    final int? sid = int.tryParse(_searchIdController.text);
    if (sid == null) {
      _showError('Invalid student ID');
      return;
    }

    _fetchPaymentsByStudentId(sid);
  }

  void _fetchPaymentsByStudentId(int studentId) async {
    try {
      final dtos = await _paymentService.getPaymentsByStudentId(studentId);
      setState(() {
        _paymentsDto = dtos;
      });
    } catch (_) {
      _showError('Failed to fetch payments');
      setState(() {
        _paymentsDto = [];
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _searchIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Student ID',
                    ),
                    onSubmitted: (_) => _searchStudentPayments(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _searchStudentPayments,
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 📄 Display student payments
            if (_paymentsDto.isNotEmpty) ...[
              Text(
                'Payments for: ${_paymentsDto[0].studentName ?? 'Unknown'}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Class: ${_paymentsDto[0].schoolClass ?? 'N/A'}, Section: ${_paymentsDto[0].section ?? 'N/A'}',
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _paymentsDto.length,
                itemBuilder: (context, idx) {
                  final dto = _paymentsDto[idx];
                  return ListTile(
                    title: Text('${dto.month} — ${dto.category}'),
                    subtitle: Text('Amount: ${dto.amount}, Paid: ${dto.paid}'),
                    trailing: Text(dto.paymentDate),
                  );
                },
              ),
              const Divider(height: 30),
            ],

            // 💳 Record payment form
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<Students>(
                      isExpanded: true,
                      hint: const Text('Select Student'),
                      value: _selectedStudent,
                      items: _students.map((s) {
                        return DropdownMenuItem<Students>(
                          value: s,
                          child: Text('${s.name ?? "Unnamed"} (ID: ${s.id})'),
                        );
                      }).toList(),
                      onChanged: (s) => setState(() => _selectedStudent = s),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedCategory,
                      items: ['Tuition Fee', 'Exam Fee'].map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val!),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Amount'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Payment Date (YYYY-MM-DD)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedMonth,
                      items: _months.map((m) {
                        return DropdownMenuItem<String>(
                          value: m,
                          child: Text(m),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedMonth = val!),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitPayment,
                      child: const Text('Record Payment'),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 30),

            // 🧾 Recent transactions
            const Text('Recent Transactions', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentPayments.length,
              itemBuilder: (context, idx) {
                final p = _recentPayments[idx];
                final name = p.student.name ?? 'Unknown';
                final dateStr = p.paymentDate.toLocal().toString().split(" ")[0];
                return ListTile(
                  title: Text('$name — ${p.category}'),
                  subtitle: Text('${p.month}, $dateStr'),
                  trailing: Text('${p.amount}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
