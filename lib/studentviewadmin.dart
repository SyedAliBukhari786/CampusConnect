import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Studentviewadmin extends StatefulWidget {
  const Studentviewadmin({super.key});

  @override
  State<Studentviewadmin> createState() => _StudentviewadminState();
}

class _StudentviewadminState extends State<Studentviewadmin> {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Student'),
        content: Text('Are you sure you want to delete this student?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteStudent(id);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }


  Future<void> deleteStudent(String id) async {
    try {
      await _firestore.collection('Students').doc(id).delete();
      setState(() {
        students.removeWhere((student) => student['id'] == id);
      });
    } catch (e) {
      print("Error deleting student: $e");
    }
  }


  Future<void> fetchStudents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Students')

          .get();

      setState(() {
        students = querySnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      print("Error fetching students: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Students'),
        backgroundColor: Colors.grey[200],
      ),
      body: students.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: Center(
                  child:  Text(
                    student['Name'] ?? 'No Name',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enrollment no: ${student['Enrollment'] ?? 'N/A'}'),
                    Text('Contact: ${student['Contact'] ?? 'N/A'}'),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDeleteConfirmationDialog(student['id']),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  // You can add further navigation to student details here
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
