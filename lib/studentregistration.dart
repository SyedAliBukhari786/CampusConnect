import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/studentlogin.dart';



class StudentRegistration extends StatefulWidget {
  const StudentRegistration({super.key});

  @override
  State<StudentRegistration> createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confrimpassword = TextEditingController();

  final TextEditingController _name= TextEditingController();
  final TextEditingController _enrollment= TextEditingController();
  final TextEditingController _contact= TextEditingController();
  String name="";
  String contact="";
  String eamil = "";
  String password = "";
  String confirmpassword = "";
  String enrollment="";










  bool _loading = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar: GestureDetector(
              onTap: () {
                // Handle registration action here

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Container(
                color: Colors.white,
                height: screenHeight * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account?",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " Login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
          backgroundColor: Colors.white,

          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),

                    Lottie.asset(
                      'assets/studentscampus.json',
                      width: 200,
                      height: 200,
                      // Adjust the width and height based on your image size
                    ),
                    Text(
                      " Student Registration",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: screenWidth * 0.08,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Text(
                      "Create your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize:
                        screenWidth * 0.04 > 400 ? 400 : screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: screenWidth * 0.8 > 400 ? 400 : screenWidth *
                            0.8,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Full Name",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.black),
                              controller: _name,
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
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Enrollment no",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.black),
                                controller: _enrollment,
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
                                    Icons.credit_card,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Contact",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.black),
                                controller: _contact,
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
                                    Icons.call,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Email",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
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
                              SizedBox(
                                height: 10,
                              ),

                              SizedBox(
                                height: 1,
                              ),

                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Password",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.blue),
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
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
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
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Confirm Password",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.blue),
                                obscureText: !isPasswordVisible,
                                controller: _confrimpassword,
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
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
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

                              SizedBox(
                                height: screenHeight * 0.04,
                              ),

                              Container(
                                width: screenWidth * 0.8 > 400
                                    ? 400
                                    : screenWidth * 0.8,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _loading ? null : _Signup();
                                    // Handle button press
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
                                        ? CircularProgressIndicator(
                                        color: Colors.white)
                                        : Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }


  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _showErrorSnackbar2(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.blue,
    ));
  }

  Future<void> _Signup() async {
    setState(() {
      _loading = true;
    });
    name=_name.text.trim();
    eamil = _emailController.text.trim();
    password = _passwordController.text.trim();
    confirmpassword = _confrimpassword.text.trim();
   enrollment= _enrollment.text.trim();
    contact=_contact.text.trim();

    // Regular expression for basic email validation
    final emailRegex =
    RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

    /* if (profileurl.isEmpty) {
      _showErrorSnackbar("Select Profile photo");
    } else if (certificate.isEmpty) {
      _showErrorSnackbar("Select Certificate");
    } else */
    if (name.isEmpty) {
      _showErrorSnackbar("Name is required");
    }
    else if (enrollment.isEmpty) {
      _showErrorSnackbar("Enrollment is required");
    }
    else if (contact.isEmpty) {
      _showErrorSnackbar("Contact is required");
    }
    else if (eamil.isEmpty) {
      _showErrorSnackbar("Email is required");
    } else if (!emailRegex.hasMatch(eamil)) {
      _showErrorSnackbar("Enter a valid email address");
    } else if (password.isEmpty) {
      _showErrorSnackbar("Password is required");
    } else if (password.length < 8) {
      _showErrorSnackbar("Password must be at least 8 characters");
    } else if (confirmpassword.isEmpty) {
      _showErrorSnackbar("Confirm Password is required");
    } else if (password != confirmpassword) {
      _showErrorSnackbar("Passwords do not match");
    }
    else {
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: eamil,
          password: password,
        );
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection("Students").doc(uid).set({
          'Name': name,
          "Contact":contact,
          "Enrollment": enrollment,
          // Add other fields you want to store
        });
        _showErrorSnackbar2("Registration Successfull");
        Navigator.pop(context);
      }
      catch(e) {
        _showErrorSnackbar(e.toString());
      }
      finally {
        setState(() {
          _loading = false;
        });
      }
    }
    setState(() {
      _loading = false;
    });
  }
}
