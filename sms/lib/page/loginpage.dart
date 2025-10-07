import 'package:flutter/material.dart';
import 'package:sms/entity/student.dart';
import 'package:sms/page/adminpage.dart';
import 'package:sms/service/student_service.dart';
import '../service/authservice.dart';

import '../student/student_profile.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService();
  final StudentService studentService = StudentService();

  bool _isLoading = false;

  Future<void> loginAndFetchProfile(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    User? user = await authService.login(email, password);

    if (user != null) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminPage())
      );
    } else {
      print('Login failed: user is null');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email)),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () => loginAndFetchProfile(context),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
