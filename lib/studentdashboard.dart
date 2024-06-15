import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'loginas.dart';




class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();


  final List<Widget> _pages = [
    DashboardScreen(),
    AlertsScreen(),
    EventsScreen(),
    BloodBankScreen(),
    StudentViewOfTeachers(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined, color: Colors.white,),
            label: 'Dashboard',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.notification_important_outlined,color: Colors.white),
            label: 'Alerts',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.calendar_month,color: Colors.white),
            label: 'Events',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.water_drop,color: Colors.white),
            label: 'Blood Bank',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person,color: Colors.white),
            label: 'Teachers',
           labelStyle: TextStyle(color: Colors.white),

          ),
        ],
        color: Colors.deepPurple,
        buttonBackgroundColor: Colors.green,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: _pages[_page],
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  FirebaseFirestore _firebaseFirestore= FirebaseFirestore.instance;
  FirebaseAuth auth= FirebaseAuth.instance;
  String studentName="";
  String? userId;
  @override
  void initState() {
    super.initState();
    getCurrentUserIdAndFetchData();
  }
  Future<void> getCurrentUserIdAndFetchData() async {
    try {
      // Get the current user ID
      User? user = FirebaseAuth.instance.currentUser;
       userId = user?.uid;

      if (userId != null) {
        // Fetch the student name from Firestore using the user ID
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection('Students')
            .doc(userId)
            .get();

        if (studentDoc.exists) {
          setState(() {
            studentName = studentDoc['Name'];
          });
        } else {
          print('No such document!');
        }
      } else {
        print('User is not signed in');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  final TextEditingController _controller = TextEditingController();

  void _showComplainDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                 // color: Colors.grey,
                  child: Lottie.asset(
                    'assets/ComplainPoll.json', // Replace with your image URL

                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Complain Registration',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      // Save to Firebase
                      await FirebaseFirestore.instance.collection('Complains').add({
                        'studentid': userId, // Replace with actual student ID
                        'complain': _controller.text,
                        'Date': FieldValue.serverTimestamp(),
                      });

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Complain submitted. Thanks for your valuable feedback!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Text('Submit Report'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 40,


                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),

                      border: Border.all(
                        color: Colors.blue,

                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.green,
                          onPressed: () {
                            // Handle edit action
                            print('Edit button pressed');
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.logout),
                          color: Colors.red,
                          onPressed: () {
                            // Handle logout action
                            auth.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  Selectin()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset("assets/newstudent.png"),
                ),
                        ),
                SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(studentName!, style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20), ),
                    SizedBox(height: 10,),
                    Text("Bahria University", style:  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 15), ),
                  ],
                )
              ],
            ),

              SizedBox(height: 20,),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Text("Campus Conect", style: TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(height: 2,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text("Features", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Container(
                            //  color: Colors.red,
                            //height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Events Notifications", textAlign: TextAlign.start,style: TextStyle(color: Colors.black, fontSize: 14),),
                                  Text("Complains Poll",textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 14, ),),
                                  Text("Faculity Tracking",textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 14),),
                                  Text("Blood Bank",textAlign: TextAlign.start ,style: TextStyle(color: Colors.black, fontSize: 14),),

                                  Text("Alerts", textAlign: TextAlign.start,style: TextStyle(color: Colors.black, fontSize: 14),),



                                ],
                              ),
                            ),


                          )),
                          Expanded(child: Container(
                            // color: Colors.blue,
                              height: 100,
                              child: Lottie.asset("assets/studentscampus.json")

                          )),



                        ],
                      )
                    ],
                  ),
                ),


              ),

              SizedBox(height: 50,),


              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text("Complaint Poll", style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Container(
                        //  color: Colors.red,
                          //height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text("Register Your Complain", style: TextStyle(color: Colors.black, fontSize: 22),),

                                GestureDetector(
                                  onTap: () {

                                    _showComplainDialog(context);
                                  },
                                  child: Container(
                                    //  color: Colors.red,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.deepPurple
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1),

                                        child:  Center(child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 16),)),


                                      ),
                                    ),
                                ),



                              ],
                            ),
                          ),
                       

                        )),
                        Expanded(child: Container(
                         // color: Colors.blue,
                          height: 100,
                          child: Lottie.asset("assets/ComplainPoll.json")

                        )),



                      ],
                    )
                  ],
                ),


              )



            ],
          ),
        ),
      )
    );
  }


  Widget buildCircularContainer(Color color, String path ) {
    return Container(
      width: 90.0,
      height: 90.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        // color: Colors.blue, // Background color of the container
        border: Border.all(
          color: Colors.lightBlue, // White border color
          width: 2.0, // Border width
        ),
      ),
      child: Center(
        child: ClipOval(
          child: Lottie.asset(
            path, // Update with your PNG image path
            width: 80.0,
            height: 80.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }


}


// only have to change the firebase   q uery

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;








  String _formatDate(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Alerts')),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: _firestore.collection('alerts').orderBy('date', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              String formattedDate = _formatDate(document['date']);
              String displayText = "${document['text']} ($formattedDate)";
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:  Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),

                  ),

                  child: ListTile(
                    leading: Icon(Icons.notification_important_outlined, color: Colors.green,),
                    title: Text(document['text']),


                  ),
                ),
              );
            }).toList(),
          );
        },
      ),

    );
  }
}




// just change the Query here
class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;







  String _formatDate(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text('Event Management')),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('events').orderBy('date', descending: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              String formattedDate = _formatDate(document['date']);
              String displayText = "${document['title']} - ${document['description']} ($formattedDate)";
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue)

                  ),
                  child: ListTile(
                    title: Center(child: Text(document['title'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),)),
                    leading: Image.asset("assets/calendar.png", height: 30,width: 30,),
                    subtitle: Column(
                      children: [
                        Text(document['description']),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end
                            ,children: [

                          Text(formattedDate),

                        ]),


                      ],
                    ),



                  ),
                ),
              );
            }).toList(),
          );
        },
      ),

    );
  }
}




class BloodBankScreen extends StatefulWidget {
  @override
  _BloodBankScreenState createState() => _BloodBankScreenState();
}

class _BloodBankScreenState extends State<BloodBankScreen> {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBloodGroupDialog(context),
        backgroundColor: Colors.white,
        child: Icon(Icons.water_drop, color: Colors.red),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showBloodGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Blood Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10,),
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
                  Navigator.of(context).pop();
                  _showBloodGroupDialog(context); // To update the dialog with the selected value
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _registerDonor(context),
              child: Text('Register'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerDonor(BuildContext context) async {
    if (selectedBloodGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a blood group before registration'),
        ),
      );
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      if (userId != null) {
        await FirebaseFirestore.instance.collection('Students').doc(userId).update({
          'BloodGroup': selectedBloodGroup,
          'Status': 'Yes',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful'),
          ),
        );
        Navigator.of(context).pop(); // Close the dialog after successful registration
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not signed in'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error registering: $e'),
        ),
      );
    }
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



class StudentViewOfTeachers extends StatefulWidget {
  const StudentViewOfTeachers({super.key});

  @override
  State<StudentViewOfTeachers> createState() => _StudentViewOfTeachersState();
}

class _StudentViewOfTeachersState extends State<StudentViewOfTeachers> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 200,
              child: Lottie.asset("assets/tt.json"),
            ),
            Text("Teachers", style: TextStyle(color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold),),
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collection('Teachers').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var teachers = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      var teacher = teachers[index].data();
                      String docId = teachers[index].id;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            title: Center(child: Text('${teacher['Name']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),)),
                            subtitle: Row(
                              children: [

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Contact: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                          Expanded(child: Text(teacher['Contact'])),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Education: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                          Expanded(child: Text(teacher['Education'])),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                          Expanded(child: Text(teacher['Status'])),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Designation: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                          Expanded(child: Text(teacher['Designation'])),
                                        ],
                                      ),
                                      SizedBox(height: 6,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                              onTap:() {

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) =>  StudentTimetableMaker(teacherId: docId)));
                                              },

                                              child: Icon(Icons.calendar_month, color: Colors.blue,size: 40,))

                                        ],
                                      ),


                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                    },
                  );
                },
              ),
            ),
          ],


        ),

      ),
      
    );
  }
}
class StudentTimetableMaker extends StatefulWidget {
  final String teacherId;

  const StudentTimetableMaker({Key? key, required this.teacherId}) : super(key: key);

  @override
  State<StudentTimetableMaker> createState() => _StudentTimetableMakerState();
}

class _StudentTimetableMakerState extends State<StudentTimetableMaker> {

  late String Teachersid;
  String? selectedDay;
  List<Map<String, dynamic>> timetable = [];

  @override
  void initState() {
    super.initState();
    Teachersid = widget.teacherId;
  }

  Future<void> _fetchTimetable(String day) async {
    final firestoreInstance = FirebaseFirestore.instance;
    final snapshot = await firestoreInstance
        .collection('Teachers')
        .doc(Teachersid)
        .collection('Timetable')
        .where('day', isEqualTo: day)
        .orderBy("startTime", descending: false)
        .get();

    setState(() {
      timetable = snapshot.docs.map((doc) => {
        ...doc.data(),
        'id': doc.id,
      }).toList();
    });
  }

  String _formatTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('h:mm a').format(dateTime);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers Timetable'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedDay,
              decoration: InputDecoration(
                labelText: 'Select Day',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              items: [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday'
              ].map((day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedDay = newValue;
                  if (selectedDay != null) {
                    _fetchTimetable(selectedDay!);
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Select a day';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: timetable.isEmpty
                ? Center(child: Text('No Timetable available'))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                border: TableBorder.all(color: Colors.blue),
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                children: [
                  TableRow(children: [
                    TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(selectedDay!,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )),
                    TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Start Time',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )),
                    TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('End Time',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )),
                    TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Class Name',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )),
                  ]),
                  ...timetable.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> record = entry.value;
                    return TableRow(children: [
                      TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(index.toString()),
                          )),
                      TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_formatTime(record['startTime'])),
                          )),
                      TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_formatTime(record['endTime'])),
                          )),
                      TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(record['className']),
                          )),
                    ]);
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),


    );
  }


}

