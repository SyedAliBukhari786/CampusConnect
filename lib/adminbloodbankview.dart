import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AdminBloodBank extends StatefulWidget {
  const AdminBloodBank({super.key});

  @override
  State<AdminBloodBank> createState() => _AdminBloodBankState();
}

class _AdminBloodBankState extends State<AdminBloodBank> {
  String? selectedBloodGroup;
  List<Map<String, dynamic>> studentsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(

          children: [
            SizedBox(height: 50,),
            DropdownButton<String>(
              value: selectedBloodGroup,
              hint: Text('Select Blood Group'),
              items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedBloodGroup = newValue;
                });
                _fetchStudents();
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: studentsList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text((index + 1).toString()),
                    ),
                    title: Text(studentsList[index]['name'] ?? 'N/A'),
                    subtitle: Text(studentsList[index]['contact'] ?? 'N/A'),
                  );
                },
              ),
            ),
          ],
        ),
      ),


    );
  }




  Future<void> _fetchStudents() async {
    if (selectedBloodGroup != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Students')
            .where('BloodGroup', isEqualTo: selectedBloodGroup)
            .get();

        setState(() {
          studentsList = querySnapshot.docs.map((doc) {
            return {
              'name': doc['Name'] ?? 'N/A',
              'contact': doc['Contact'] ?? 'N/A',
            };
          }).toList();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching students: $e'),
          ),
        );
      }
    }
  }
}