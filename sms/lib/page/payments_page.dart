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

  List<Student> _students = [];
  Student? _selectedStudent;

  List<PaymentDTO> _paymentsDto = [];
  List<Payment> _recentPayments = [];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _selectedMonth = 'January';
  String _selectedCategory = 'Tuition Fee';

  final List<String> _months = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
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
      // handle error
    }
  }

  void _loadRecentPayments() async {
    try {
      var payments = await _paymentService.getAllPayments();
      setState(() {
        _recentPayments = payments;
      });
    } catch (e) {
      // error
    }
  }

  void _submitPayment() async {
    if (_selectedStudent == null || _amountController.text.isEmpty || _dateController.text.isEmpty) {
      _showError('Please fill all fields');
      return;
    }
    double? amt = double.tryParse(_amountController.text);
    if (amt == null) {
      _showError('Invalid amount');
      return;
    }
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(_dateController.text);
    } catch (e) {
      _showError('Invalid date');
      return;
    }

    Payment newPayment = Payment(
      id: 0,
      month: _selectedMonth,
      category: _selectedCategory,
      amount: amt,
      paid: true,
      paymentDate: parsedDate,
      student: _selectedStudent!,
    );

    try {
      await _paymentService.createPayment(newPayment);
      _showMessage('Payment recorded successfully');
      _loadRecentPayments();
    } catch (e) {
      _showError('Failed to record payment');
    }
  }

  void _searchStudentPayments(int studentId) async {
    try {
      var dtos = await _paymentService.getPaymentsByStudentId(studentId);
      setState(() {
        _paymentsDto = dtos;
      });
    } catch (e) {
      setState(() {
        _paymentsDto = [];
      });
      _showError('Error fetching payments');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payments')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Search by Student ID / View payments
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Student ID'),
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        int? sid = int.tryParse(value);
                        if (sid != null) {
                          _searchStudentPayments(sid);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // optionally use a button instead of onSubmitted
                    },
                    child: Text('Search'),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Display DTO payments if any
              if (_paymentsDto.isNotEmpty) ...[
                Text(
                  'Payments for: ${_paymentsDto[0].studentName}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                    'Class: ${_paymentsDto[0].schoolClass}, Section: ${_paymentsDto[0].section}'),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
              ],

              Divider(height: 30),

              // Form to record new payment
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<Student>(
                        isExpanded: true,
                        hint: Text('Select Student'),
                        value: _selectedStudent,
                        items: _students.map((s) {
                          return DropdownMenuItem<Student>(
                            value: s,
                            child: Text(s.name),
                          );
                        }).toList(),
                        onChanged: (s) {
                          setState(() {
                            _selectedStudent = s;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedCategory,
                        items: ['Tuition Fee', 'Exam Fee'].map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedCategory = val!;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Amount'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _dateController,
                        decoration: InputDecoration(labelText: 'Payment Date (YYYY-MM-DD)'),
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedMonth,
                        items: _months.map((m) {
                          return DropdownMenuItem<String>(
                            value: m,
                            child: Text(m),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedMonth = val!;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitPayment,
                        child: Text('Record Payment'),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(height: 30),

              // Recent transactions
              Text('Recent Transactions'),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _recentPayments.length,
                itemBuilder: (context, idx) {
                  final p = _recentPayments[idx];
                  return ListTile(
                    title: Text('${p.student.name} — ${p.category}'),
                    subtitle: Text('${p.month}, ${p.paymentDate.toLocal().toString().split(" ")[0]}'),
                    trailing: Text(p.amount.toString()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
