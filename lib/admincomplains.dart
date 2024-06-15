import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminComplains extends StatefulWidget {
  const AdminComplains({super.key});

  @override
  State<AdminComplains> createState() => _AdminComplainsState();
}

class _AdminComplainsState extends State<AdminComplains> {
  String formatDate(Timestamp timestamp) {
    var date = timestamp.toDate();
    var formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  void deleteComplain(String complainId) async {
    await FirebaseFirestore.instance.collection('Complains').doc(complainId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Complaint deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaints'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Complains').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var complains = snapshot.data!.docs;

          return ListView.builder(
            itemCount: complains.length,
            itemBuilder: (context, index) {
              var complain = complains[index];
              var complainId = complain.id; // Get the document ID
              var studentId = complain['studentid'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('Students').doc(studentId).get(),
                builder: (context, studentSnapshot) {
                  if (studentSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }

                  if (!studentSnapshot.hasData || studentSnapshot.data == null) {
                    return ListTile(
                      title: Text('Student data not found'),
                      subtitle: Text(complain['complain']),
                      trailing: Text(
                        formatDate(complain['Date']),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    );
                  }

                  var studentData = studentSnapshot.data!.data() as Map<String, dynamic>?;
                  if (studentData == null) {
                    return ListTile(
                      title: Text('Student data not found'),
                      subtitle: Text(complain['complain']),
                      trailing: Text(
                        formatDate(complain['Date']),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    );
                  }

                  var studentName = studentData['Name'] ?? 'Unknown';
                  var studentEnrollment = studentData['Enrollment'] ?? 'Unknown';

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$studentName',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$studentEnrollment',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(complain['complain']),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  formatDate(complain['Date']),
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    deleteComplain(complainId);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}