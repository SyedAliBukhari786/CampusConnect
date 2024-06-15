/*import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/teachersdashboard.dart';

import 'admindashboard.dart'; // Add this import for the admin dashboard
import 'studentdashboard.dart'; // Add this import for the student dashboard
import 'loginas.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      home: FutureBuilder<Widget>(
        future: _checkUserType(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else {
            return snapshot.data ?? Selectin();
          }
        },
      ),
    );
  }

  Future<Widget> _checkUserType() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return Selectin();
    }

    final currentUserId = firebaseUser.uid;

    final adminDoc = await FirebaseFirestore.instance.collection('Admin').doc(currentUserId).get();
    if (adminDoc.exists) {
      return AdminDashboard();
    }

    final teacherDoc = await FirebaseFirestore.instance.collection('Teachers').doc(currentUserId).get();
    if (teacherDoc.exists) {
      return TeachersDashboard();
    }

    final studentDoc = await FirebaseFirestore.instance.collection('Students').doc(currentUserId).get();
    if (studentDoc.exists) {
      return StudentDashboard();
    }

    return Selectin(); // Fallback in case the user is not found in any collection
  }
}



 */
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> getPrediction(String tweet) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/predict'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'tweet': tweet,
    }),
  );

  if (response.statusCode == 200) {
    final prediction = jsonDecode(response.body)['prediction'];
    print('Prediction: $prediction');
  } else {
    throw Exception('Failed to get prediction');
  }
}


void main () {
  getPrediction("Hellooo");

}