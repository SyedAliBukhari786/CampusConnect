import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/adminlogin.dart';
import 'package:untitled/studentlogin.dart';



class Selectin extends StatefulWidget {
  const Selectin({Key? key}) : super(key: key);

  @override
  State<Selectin> createState() => _SelectinState();
}

class _SelectinState extends State<Selectin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Text("Continue as", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>   AdminLogin()),
                  );
                },
                child: Container(
                  height: 250,
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Center(
                            child: Text(
                              "Admin",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                            child: Lottie.asset("assets/admin.json")
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  LoginPage()));

                },
                child: Container(
                  height: 250,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Center(
                            child: Text(
                              "Student",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                            child: Lottie.asset("assets/studentscampus.json")
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()));

                },
                child: Container(
                  height: 250,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Center(
                            child: Text(
                              "Teacher",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                            child: Lottie.asset("assets/tt.json")
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
