import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/routenames.dart';

class Appointment {
  final String firstName;
  final String lastName;
  final DateTime date;
  final String time;
  final String type;

  Appointment(
      {required this.firstName,
      required this.lastName,
      required this.date,
      required this.time,
      required this.type});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      firstName: json['f_name'].toString(),
      lastName: json['l_name'].toString(),
      date: DateTime.parse(json['date']),
      time: json['time'].toString(),
      type: json['type_of_appointment'].toString(),
    );
  }
}

class AppointmentList extends StatefulWidget {
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List<Appointment> appointments = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      // Redirect to login if token is not available
      Navigator.pushReplacementNamed(context, Routenames.login);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://itjoblinks.com/public/api/appointments'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          // If the response is already a list, directly use it
          setState(() {
            appointments =
                jsonData.map((json) => Appointment.fromJson(json)).toList();
            isLoading = false;
          });
        } else if (jsonData is Map && jsonData.containsKey('appointments')) {
          // If the response is a map with an 'appointments' key, extract the appointments
          final List<dynamic> appointmentData = jsonData['appointments'];
          setState(() {
            appointments = appointmentData
                .map((json) => Appointment.fromJson(json))
                .toList();
            isLoading = false;
          });
        } else {
          throw Exception('Appointments data is not in the expected format.');
        }
      } else {
        throw Exception('Failed to fetch appointments: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load appointments: $error';
        isLoading = false;
      });
    }
  }
 String _formatTime(String timeString) {
  final parts = timeString.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return DateFormat.jm().format(DateTime(2022, 1, 1, hour, minute));
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
    backgroundColor: Colors.blue,
    title: Text('Appointments',style: TextStyle(color: Colors.white),),
    centerTitle: true, // Adjust as needed
    leading: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.arrow_back_ios, // iOS back arrow icon
        color: Colors.white, // Adjust as needed
      ),
    ),),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : appointments.isEmpty
                    ? Center(child: Text('No appointments available'))
                    : ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return Padding(
                            padding: const EdgeInsets.only(left:8.0,right: 8,top: 16),
                            child: Center(
                              child: Container(
                                height: screenHeight * 0.23,
                                width: screenWidth * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Patient\'s Name: ' ,
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  '${appointment.firstName} ${appointment.lastName}',
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.blue,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                    width:
                                                        8), // Adjust spacing between icon and text
                                                Text(
                                                  'Date: ',
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${DateFormat("MMM dd, yyyy").format(appointment.date)}',
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  color: Colors.blue,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                    width:
                                                        5), // Adjust spacing between icon and text
                                                Text(
                                                  'Time: ',
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${_formatTime(appointment.time)}',
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: // Adjust spacing between icon and text
                                                Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Appointment: ',
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                '${appointment.type}',
                                                style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                                ],
                                              ),
                                              
                                            ),
                                          ),
                                        ]),
                                        Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.23, // Adjust height as needed
              width: screenWidth * 0.13, // Adjust width as needed
              decoration: BoxDecoration(color: Colors.lightBlue,borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10))),
              child: Center(
                // child: Icon(
                //   Icons.add,
                //   color: Colors.white,
                // ),
              ),
            ),
          ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }));
  }
}
