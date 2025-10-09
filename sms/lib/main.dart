import 'package:flutter/material.dart';
import 'package:sms/page/payments_page.dart';
import 'package:sms/page/result_page.dart';
import 'package:sms/page/school_classes_page.dart';
import 'package:sms/page/sections_page.dart';
import 'package:sms/page/students_page.dart';
import 'package:sms/page/teachers_page.dart';

void main() {
  runApp(SchoolManagementApp());
}

class SchoolManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(), // Optional Home screen
        '/payments': (context) => PaymentsPage(),
        '/results': (context) => ResultPage(),
        '/classes': (context) => SchoolClassesPage(),
        '/sections': (context) => SectionsPage(),
        '/students': (context) => StudentsPage(),
        '/teachers': (context) => TeachersPage(),
      },
    );
  }
}

// Optional: Home page with navigation buttons to all others
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/payments'),
            child: Text('Payments'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/results'),
            child: Text('Results'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/classes'),
            child: Text('Classes'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/sections'),
            child: Text('Sections'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/students'),
            child: Text('Students'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/teachers'),
            child: Text('Teachers'),
          ),
        ],
      ),
    );
  }
}
