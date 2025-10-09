// students_page.dart
import 'package:flutter/material.dart';
import 'package:sms/entity/student.dart';
import 'package:sms/service/student_service.dart';


class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final StudentService _studentService = StudentService();
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = _studentService.getAllStudents();
    print(_studentsFuture);
  }

  void _deleteStudent(int id) async {
    try {
      await _studentService.deleteStudent(id);
      setState(() {
        _studentsFuture = _studentService.getAllStudents();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting student')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Students')),
      body: FutureBuilder<List<Student>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading students'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No students found'));
          }

          final students = snapshot.data!;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'http://localhost:8080/images/students/${student.photo}'),
                ),
                title: Text(student.name),
                subtitle: Text('Class: ${student.schoolClass.name}, Section: ${student.section.name}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteStudent(student.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
