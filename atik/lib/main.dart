import 'package:atik/page/login.dart';
import 'package:atik/page/registrationpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
 }

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

        home: Registration()


    );
  }
}
