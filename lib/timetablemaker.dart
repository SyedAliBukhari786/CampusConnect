import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimetableMaker extends StatefulWidget {
  final String Teachersid;

  TimetableMaker({required this.Teachersid});

  @override
  _TimetableMakerState createState() => _TimetableMakerState();
}

class _TimetableMakerState extends State<TimetableMaker> {
  late String Teachersid;
  String? selectedDay;
  List<Map<String, dynamic>> timetable = [];

  @override
  void initState() {
    super.initState();
    Teachersid = widget.Teachersid;
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

  Future<void> _deleteTimetableRecord(String id) async {
    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance
        .collection('Teachers')
        .doc(Teachersid)
        .collection('Timetable')
        .doc(id)
        .delete();

    if (selectedDay != null) {
      _fetchTimetable(selectedDay!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable Maker'),
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
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteTimetableRecord(record['id']);
                              },
                            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddClassDialog(context);
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.calendar_month,
          color: Colors.white,
        ),
        tooltip: 'Add Class',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _showAddClassDialog(BuildContext context) async {
    final TextEditingController _startTimeController = TextEditingController();
    final TextEditingController _endTimeController = TextEditingController();
    final TextEditingController _classNameController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    TimeOfDay? selectedStartTime;
    TimeOfDay? selectedEndTime;
    String? selectedDialogDay;

    Future<void> _selectTime(BuildContext context, TextEditingController controller,
        {required bool isStartTime}) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        setState(() {
          if (isStartTime) {
            selectedStartTime = picked;
          } else {
            selectedEndTime = picked;
          }
          controller.text = picked.format(context);
        });
      }
    }

    DateTime _convertTimeOfDayToDateTime(TimeOfDay timeOfDay) {
      // Set a fixed date (e.g., January 1, 2000)
      return DateTime(2000, 1, 1, timeOfDay.hour, timeOfDay.minute);
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Class'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    value: selectedDialogDay,
                    decoration: InputDecoration(
                      labelText: 'Day',
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
                        selectedDialogDay = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Select a day';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _startTimeController,
                    decoration: InputDecoration(
                      labelText: 'Starting Time',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time, color: Colors.blue),
                        onPressed: () {
                          _selectTime(context, _startTimeController, isStartTime: true);
                        },
                      ),
                    ),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Time is not selected';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _endTimeController,
                    decoration: InputDecoration(
                      labelText: 'Ending Time',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time, color: Colors.blue),
                        onPressed: () {
                          _selectTime(context, _endTimeController, isStartTime: false);
                        },
                      ),
                    ),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Time is not selected';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _classNameController,
                    decoration: InputDecoration(
                      labelText: 'Class Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter class name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Convert TimeOfDay to DateTime with fixed date
                  DateTime startDateTime = _convertTimeOfDayToDateTime(selectedStartTime!);
                  DateTime endDateTime = _convertTimeOfDayToDateTime(selectedEndTime!);

                  // Add to Firestore
                  final firestoreInstance = FirebaseFirestore.instance;
                  await firestoreInstance.collection('Teachers')
                      .doc(Teachersid)
                      .collection('Timetable')
                      .add({
                    'day': selectedDialogDay,
                    'startTime': Timestamp.fromDate(startDateTime),
                    'endTime': Timestamp.fromDate(endDateTime),
                    'className': _classNameController.text,
                  });

                  if (selectedDay == selectedDialogDay) {
                    _fetchTimetable(selectedDay!);
                  }

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
