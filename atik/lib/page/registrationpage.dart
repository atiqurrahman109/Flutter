import 'dart:io';
import 'dart:typed_data';

import 'package:atik/page/login.dart';
import 'package:atik/service/authservice.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';
import 'package:radio_group_v2/widgets/views/radio_group.dart' as v2;

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final RadioGroupController genderController = RadioGroupController();
  final DateTimeFieldPickerPlatform dob = DateTimeFieldPickerPlatform.material;

  String? selectedGender;
  DateTime? selectedDOB;

  XFile? selectedImage;
  Uint8List? webImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D83F2), Color(0xFF9DCEF2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Student Registration",
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Form Fields
                      buildTextFormField(
                        controller: name,
                        label: "Full Name",
                        icon: Icons.person,
                        validator: (value) =>
                        value!.isEmpty ? "Enter your name" : null,
                      ),
                      const SizedBox(height: 16),
                      buildTextFormField(
                        controller: email,
                        label: "Email",
                        icon: Icons.email,
                        validator: (value) {
                          if (value!.isEmpty) return "Enter email";
                          if (!value.contains('@')) return "Invalid email";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextFormField(
                        controller: password,
                        label: "Password",
                        icon: Icons.lock,
                        obscureText: _obscurePassword,
                        toggleObscure: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextFormField(
                        controller: confirmPassword,
                        label: "Confirm Password",
                        icon: Icons.lock_outline,
                        obscureText: _obscureConfirmPassword,
                        toggleObscure: () => setState(
                                () => _obscureConfirmPassword = !_obscureConfirmPassword),
                        validator: (value) {
                          if (value != password.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextFormField(
                        controller: cell,
                        label: "Cell",
                        icon: Icons.phone,
                        validator: (value) =>
                        value!.isEmpty ? "Enter phone number" : null,
                      ),
                      const SizedBox(height: 16),
                      buildTextFormField(
                        controller: address,
                        label: "Address",
                        icon: Icons.home,
                        validator: (value) =>
                        value!.isEmpty ? "Enter address" : null,
                      ),
                      const SizedBox(height: 16),

                      DateTimeFormField(
                        decoration: InputDecoration(
                          labelText: "Date of Birth",
                          filled: true,
                          fillColor: const Color(0xFFF0F4FF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.calendar_today, color: Colors.indigo),
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        pickerPlatform: dob,
                        onChanged: (DateTime? value) {
                          setState(() {
                            selectedDOB = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            v2.RadioGroup(
                              controller: genderController,
                              values: const ["Male", "Female", "Other"],
                              indexOfDefault: 0,
                              orientation: v2.RadioGroupOrientation.horizontal,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedGender = newValue.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        icon: const Icon(Icons.image),
                        label: const Text("Upload Image"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.indigo,
                        ),
                        onPressed: pickImage,
                      ),
                      if (kIsWeb && webImage != null)
                        Image.memory(webImage!,
                            height: 100, width: 100, fit: BoxFit.cover)
                      else if (!kIsWeb && selectedImage != null)
                        Image.file(File(selectedImage!.path),
                            height: 100, width: 100, fit: BoxFit.cover),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            color: Colors.indigo,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    VoidCallback? toggleObscure,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF0F4FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.indigo),
        suffixIcon: toggleObscure != null
            ? IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey),
          onPressed: toggleObscure,
        )
            : null,
      ),
      validator: validator,
    );
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webImage = pickedImage;
        });
      }
    } else {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage;
        });
      }
    }
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (kIsWeb && webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    if (!kIsWeb && selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    final user = {
      "name": name.text,
      "email": email.text,
      "phone": cell.text,
      "password": password.text,
    };

    final student = {
      "name": name.text,
      "email": email.text,
      "phone": cell.text,
      "gender": selectedGender ?? "Other",
      "address": address.text,
      "dateOfBirth": selectedDOB?.toIso8601String() ?? "",
    };

    final apiService = AuthService();
    bool success = false;

    if (kIsWeb && webImage != null) {
      success = await apiService.registerStudentWeb(
        user: user,
        student: student,
        photoBytes: webImage!,
      );
    } else if (selectedImage != null) {
      success = await apiService.registerStudentWeb(
        user: user,
        student: student,
        photoFile: File(selectedImage!.path),
      );
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Failed")),
      );
    }
  }
}
