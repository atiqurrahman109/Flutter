

import 'package:atik/page/adminpage.dart';
import 'package:atik/page/registrationpage.dart';
import 'package:atik/service/authservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatelessWidget{



  // TextEditingController? email;
  // TextEditingController? password;
  final TextEditingController email= TextEditingController();
  final TextEditingController password= TextEditingController();
  bool _obscurePassword = true;

  final storage= new FlutterSecureStorage();
  AuthService authService=new AuthService();


  @override
  Widget build(BuildContext context) {



   return Scaffold(
     body: Padding(
         padding: EdgeInsets.all(16.0),
       
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email)
                ),
                
              ),
              
              SizedBox(
                height: 30.0,
              ),


              TextField(
                controller: password,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.password)
                ),
                obscureText: true,

              ),

              SizedBox(
                height: 30.0,
              ),


              ElevatedButton(
                  onPressed:() {
                   loginUser(context);

                  },
                  child: Text(
                  "Login",
                 style: TextStyle(
                   fontSize: 20.0,
                   fontWeight: FontWeight.w600,

                 ),
              ),


                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  foregroundColor:Colors.white,
                ),

              ),

              SizedBox(
                height: 20.0,
              ),


              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Registration()),
                  );
                },
                child: Text(
                  'Registration',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )

            ],
          ),

     ),

   );
  }

  Future<void> loginUser(BuildContext context) async{

    try{
      final response = await authService.login(email.text, password.text);

      //successful login and navigation
      final role = await authService.getUserRole();
      if(role=="ADMIN"){

        Navigator.pushReplacement(
          context,
        MaterialPageRoute(builder: (context)=> AdminPage()));

      }
      else{
        print("Unknown error:$role");

      }
    }
    catch(error){
      print("login in error:$error");

    }

  }

}