import 'package:flutter/material.dart';
import 'package:sms/entity/teacher.dart';
import 'package:sms/service/teacher_service.dart';

class TeachersPage extends StatefulWidget {
  @override
  _TeachersPageState createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  final TeacherService _teacherService = TeacherService();
  late Future<List<Teacher>> _teachersFuture;

  @override
  void initState() {
    super.initState();
    _teachersFuture = _teacherService.getAllTeachers();
  }

  void _deleteTeacher(int id) async {
    try {
      await _teacherService.deleteTeacher(id);
      setState(() {
        _teachersFuture = _teacherService.getAllTeachers(); // Refresh list
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete teacher')),
      );
    }
  }

  void _viewTeacherProfile(Teacher teacher) {
    print("View profile of ${teacher.name}");
  }

  void _updateTeacher(Teacher teacher) {
    print("Update teacher: ${teacher.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Teachers")),
      body: FutureBuilder<List<Teacher>>(
        future: _teachersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error loading teachers: ${snapshot.error}");
            return Center(child: Text('Error loading teachers: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No teachers found'));
          }

          final teachers = snapshot.data!;
          return ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final teacher = teachers[index];
              return ListTile(
                leading: CircleAvatar(
                  // backgroundImage: NetworkImage(
                  //   'http://192.168.0.105:8080/images/teachers/${teacher.photo}',
                  // ),
                  // onBackgroundImageError: (_, __) {
                  //   print("Failed to load image for ${teacher.name}");
                  // },
                ),
                title: Text(teacher.name),
                subtitle: Text(teacher.user.email), // email from user object
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      icon: Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () => _viewTeacherProfile(teacher),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.grey),
                      onPressed: () => _updateTeacher(teacher),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTeacher(teacher.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
