import 'package:flutter/material.dart';
import 'package:sms/entity/result.dart';
import 'package:sms/service/result_service.dart';


class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final ResultService _resultService = ResultService();

  List<Result> _results = [];
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  void _loadResults() async {
    try {
      final results = await _resultService.getAllResults();
      setState(() {
        _results = results;
      });
    } catch (e) {
      _showMessage('Failed to load results');
    }
  }

  String _calculateGrade(int marks) {
    if (marks >= 80) return 'A+';
    if (marks >= 70) return 'A';
    if (marks >= 60) return 'A-';
    if (marks >= 50) return 'B';
    if (marks >= 40) return 'C';
    if (marks >= 33) return 'D';
    return 'F';
  }

  void _submitResult() async {
    if (_subjectController.text.isEmpty || _marksController.text.isEmpty) {
      _showMessage('All fields are required');
      return;
    }

    final int? marks = int.tryParse(_marksController.text);
    if (marks == null) {
      _showMessage('Invalid marks');
      return;
    }

    final grade = _calculateGrade(marks);

    final result = Result(
      id: 0, // will be set by backend
      subject: _subjectController.text,
      marks: marks,
      grade: grade,
    );

    try {
      await _resultService.createResult(result);
      _showMessage('Result added');
      _subjectController.clear();
      _marksController.clear();
      _loadResults();
    } catch (e) {
      _showMessage('Failed to add result');
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _marksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exam Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: _marksController,
              decoration: InputDecoration(labelText: 'Marks'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitResult,
              child: Text('Add Result'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _results.isEmpty
                  ? Center(child: Text('No results found'))
                  : ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final result = _results[index];
                  return Card(
                    child: ListTile(
                      title: Text(result.subject),
                      subtitle: Text('Marks: ${result.marks}, Grade: ${result.grade}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
