
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/studentdashboard.dart';
import 'package:untitled/studentregistration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {



 final FirebaseAuth _auth = FirebaseAuth.instance;
 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  bool isPasswordVisible = false;
  @override
  void initState() {
    super.initState();


  }







  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return
      SafeArea(child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: GestureDetector(
            onTap: () {
              // Handle registration action here

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentRegistration()),
              ).then((value) => null);
            },

            child: Container(
              color: Colors.white,
              height: screenHeight *0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text(
                    "Don't have an Account?",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " Register",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],

              ),
            )
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,

          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/studentscampus.json',
                    width: 200,
                    height: 200,
                    // Adjust the width and height based on your image size
                  ),
                  SizedBox( height: 10,),
                  Text("Campus Connect",  style:  GoogleFonts.oldenburg(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),



                  SizedBox( height: 10,),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: screenWidth * 0.8 > 400 ? 400 : screenWidth * 0.8,

                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children :[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text("Email", style: TextStyle(color: Colors.black),),
                            ),
                            SizedBox(height: 1,),
                            TextField(

                              style: TextStyle(color: Colors.black),
                             controller: _emailController,
                              decoration: InputDecoration(

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.blue,
                                ),
                              ),

                            ),
                            SizedBox(height: 20,),


                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text("Password", style: TextStyle(color: Colors.black),),
                            ),
                            SizedBox(height: 1,),
                            TextField(

                              style: TextStyle(color: Colors.black),
                              obscureText: !isPasswordVisible,
                               controller: _passwordController,
                              decoration: InputDecoration(

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blue,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),


                              ),

                            ),
                            SizedBox( height: 30,),



                            Center(
                              child: Container(
                                width: screenWidth * 0.8 > 400 ? 400 : screenWidth * 0.5,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _loading ? null : _login();  // Handle button press
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: _loading
                                        ? CircularProgressIndicator(color: Colors.white)
                                        : Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),]
                      ),
                    ),
                  )






                ],





              ),
            ),
          ),



        ),

      ));
  }

  Future<void> _login() async {
    if (_validateInputs()) {
      setState(() {
        _loading = true;
      });

      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentDashboard()),
        ).then((_) {
          // This block will be executed when the Registration screen is popped
          exit(0);
        });

      } catch (e) {
        _showErrorSnackbar(e.toString());
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  bool _validateInputs() {
    if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
      _showErrorSnackbar('Enter a valid email address.');
      return false;
    } else if (_passwordController.text.isEmpty) {
      _showErrorSnackbar('Enter a valid password.');
      return false;
    }
    return true;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
