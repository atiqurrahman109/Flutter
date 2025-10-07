import 'package:flutter/material.dart';
import 'package:sms/entity/student.dart';
import 'package:sms/service/authservice.dart';
import 'package:sms/service/student_service.dart';
import 'package:sms/student/student_profile.dart';
// make sure this path is correct

void loginAndFetchProfile(BuildContext context) async {
  AuthService authService = AuthService();
  StudentService studentService = StudentService();

  // 1. Login
  User? user = await authService.login("student@example.com", "123456");

  if (user != null) {
    print("Login successful for: ${user.username}");

    // 2. Fetch profile using user.id
    Student? profile = await studentService.fetchStudentProfile(user.id!);

    if (profile != null) {
      print("Student Name: ${profile.name}");

      // 3. Navigate to Profile Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentProfile(profile: profile.toJson()),
        ),
      );
    } else {
      print("❌ Failed to fetch profile");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile')),
      );
    }
  } else {
    print("❌ Login failed");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid credentials')),
    );
  }
}
