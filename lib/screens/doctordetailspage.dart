import 'package:clientwork/components/button.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'paymentmethod.dart';

class doctordetailspage extends StatelessWidget {
  const doctordetailspage({super.key, required this.doctorDetails});
  final Map<String, dynamic> doctorDetails;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
    backgroundColor: Colors.blue,
    title: Text('Doctor Details',style: TextStyle(color: Colors.white),),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 8),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    height: screenHeight * 0.12,
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 40.0,
                              child: Icon(
                                FontAwesomeIcons.user,
                                size: 40,
                                color: Colors.black,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 8, top: 14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorDetails['name'],
                                style: TextStyle(fontSize: 20,color: Colors.white),
                              ),
                              Text(
                                doctorDetails['designation'],
                                style: TextStyle(fontSize: 20,color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 14),
            Stack(
              children: [
                Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: Stack(
                    children: [
                      Container(
                          height: screenHeight * 0.65,
                          width: screenWidth * 0.93,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.blueAccent, width: .4)),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'About Me',
                                style:GoogleFonts.bebasNeue(color: Colors.black,fontSize: 32),
                              ),
                            ),
                            
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0,bottom: 8,left: 20,right: 20),
                                  child:
                                      Text(formatDoctorDetails(doctorDetails),
                                          style: TextStyle(
                                            fontSize: 18,
                                            height: 1.5,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.justify),
                                ),
                                Container(
                                  height: screenHeight * 0.2,
                                                          width: screenWidth * 0.8,
                                  padding: EdgeInsets.only(
                                      bottom: 8, left: 16, right: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'The consultation charges are as follows:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '- Standard Weekday Charges: ${doctorDetails['s_cons_weekday']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        '- Standard Weekend Charges: ${doctorDetails['s_cons_weekend']}',
                                        style: TextStyle(fontSize: 16,),
                                      ),
                                      Text(
                                        '- Long Weekday Charges: ${doctorDetails['l_cons_weekday']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        '- Long Weekend Charges: ${doctorDetails['l_cons_weekend']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                     
                                    ],
                                  ),
                                ),
                                 SizedBox(height: 40),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Containers(
                                              clr: Colors.blue,
                                              txt: 'Book Consultation',
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            paymentmethod(
                                                              doctorDetails: {
                                                                ...doctorDetails,
                                                                'doctor_id':
                                                                    doctorDetails[
                                                                        'id'],
                                                              },
                                                            )));
                                              }),
                                        ),
                                      )
                              ],
                            ),
                          ])),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

String formatDoctorDetails(Map<String, dynamic> details) {
  return '''
 ${details['name']} is a ${details['designation']} with ${details['experience']} of experience and has completed their education in ${details['education']}.
''';
}
