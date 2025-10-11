import 'package:flutter/material.dart';
import 'package:sms/entity/student.dart';
import 'package:sms/service/student_service.dart';



class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final StudentService _studentService = StudentService();
  late Future<List<Students>> _futureStudents;

  @override
  void initState() {
    super.initState();
    _futureStudents = _studentService.getAllStudents();
  }

  void _refresh() {
    setState(() {
      _futureStudents = _studentService.getAllStudents();
    });
  }

  void _deleteStudent(int? id) async {
    if (id == null) return;
    try {
      await _studentService.deleteStudent(id);
      _refresh();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: FutureBuilder<List<Students>>(
        future: _futureStudents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found'));
          } else {
            final students = snapshot.data!;
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final s = students[index];
                String className = s.schoolClass?.name ?? 'N/A';
                String sectionName = s.section?.name ?? 'N/A';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: s.photo != null
                        ? NetworkImage('http://10.0.2.2:8080/images/students/${s.photo}')
                        : null,
                    onBackgroundImageError: (_, __) {
                      print("Image load error for ${s.name}");
                    },
                  ),
                  title: Text(s.name ?? 'No name'),
                  subtitle: Text('Class: $className, Section: $sectionName'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteStudent(s.id),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
