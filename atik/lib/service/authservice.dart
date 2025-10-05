
import 'dart:convert';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{

  final String baseUrl = "http://localhost:8085";

  Future<bool> login(String email,String password) async{

    final url = Uri.parse("$baseUrl/auth/login");
    final headers ={"Content-type":"application/json"};

    final body = jsonEncode({"email":email,"password":password});
     final response =await http.post(url,headers:headers,body:body);

     if(response.statusCode == 200){
       final data = jsonDecode(response.body);
       String token =data["Token"];

       Map<String,dynamic> payload = Jwt.parseJwt(token);
       String role= payload["Role"];

       //storre token and roles
       SharedPreferences pref = await SharedPreferences.getInstance();
       await pref.setString("authToken", token);
       await pref.setString("userRole", role);

       return true;

     }
     else{
       print("failed to login:${response.body}");
       return false;

     }
    }


    // Future<String?> getUserRole()async{
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // print(pref.getString("userRole"));
    // return pref.getString("userRole");
    //
    // }

  Future<bool> registerStudentWeb({
    required Map<String, dynamic> user,      // User data (username, email, password, etc.)
    required Map<String, dynamic> student, // JobSeeker-specific data (skills, CV, etc.)
    File? photoFile,                         // Photo file (used on mobile/desktop platforms)
    Uint8List? photoBytes,                   // Photo bytes (used on web platforms)
  }) async {
    // Create a multipart HTTP request (POST) to your backend API
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/user/registerstudent'), // Backend endpoint
    );

    // Convert User map into JSON string and add to request fields
    request.fields['user'] = jsonEncode(user);

    // Convert JobSeeker map into JSON string and add to request fields
    request.fields['student'] = jsonEncode(student);

    // ---------------------- IMAGE HANDLING ----------------------

    // If photoBytes is available (e.g., from web image picker)
    if (photoBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'photo',                // backend expects field name 'photo'
          photoBytes,             // Uint8List is valid here
          filename: 'profile.png' // arbitrary filename for backend
      ));
    }

    // If photoFile is provided (mobile/desktop), attach it
    else if (photoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'photo',                // backend expects field name 'photo'
        photoFile.path,         // file path from File object
      ));
    }

    // ---------------------- SEND REQUEST ----------------------

    // Send the request to backend
    var response = await request.send();

    // Return true if response code is 200 (success)
    return response.statusCode == 200;
  }


  //teacher

  Future<bool> registerTeacherWeb({
    required Map<String, dynamic> user,      // User data (username, email, password, etc.)
    required Map<String, dynamic> teacher, // JobSeeker-specific data (skills, CV, etc.)
    File? photoFile,                         // Photo file (used on mobile/desktop platforms)
    Uint8List? photoBytes,                   // Photo bytes (used on web platforms)
  }) async {
    // Create a multipart HTTP request (POST) to your backend API
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/user/register-teacher'), // Backend endpoint
    );

    // Convert User map into JSON string and add to request fields
    request.fields['user'] = jsonEncode(user);

    // Convert JobSeeker map into JSON string and add to request fields
    request.fields['teacher'] = jsonEncode(teacher);

    // ---------------------- IMAGE HANDLING ----------------------

    // If photoBytes is available (e.g., from web image picker)
    if (photoBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'photo',                // backend expects field name 'photo'
          photoBytes,             // Uint8List is valid here
          filename: 'profile.png' // arbitrary filename for backend
      ));
    }

    // If photoFile is provided (mobile/desktop), attach it
    else if (photoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'photo',                // backend expects field name 'photo'
        photoFile.path,         // file path from File object
      ));
    }

    // ---------------------- SEND REQUEST ----------------------

    // Send the request to backend
    var response = await request.send();

    // Return true if response code is 200 (success)
    return response.statusCode == 200;
  }


  Future<String?> getUserRole() async{
        SharedPreferences pref = await SharedPreferences.getInstance();
        print(pref.getString("userRole"));
         return pref.getString("userRole");


      }
    }




