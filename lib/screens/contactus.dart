import 'package:clientwork/components/button.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/routenames.dart';

class contactus extends StatefulWidget {
  const contactus({super.key});

  @override
  State<contactus> createState() => _contactusState();
}

class _contactusState extends State<contactus> {
  
  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
   
     
      appBar: AppBar(
    backgroundColor: Colors.blue,
    title: Text('Contact us',style: TextStyle(color: Colors.white),),
    centerTitle: true,
    leading: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routenames.bottomnavbar);
      },
      child: Icon(
        Icons.arrow_back_ios, // iOS back arrow icon
        color: Colors.white, // Adjust as needed
      ),
    ),),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Get in Touch',
                    style: GoogleFonts.bebasNeue(
                        color: Colors.black,
                        fontSize: 35,
                        
                        )),
              )),
              Container(
                height: screenHeight * 0.2,
                width: screenWidth *0.9,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                color: Colors.blue[100],
                border: Border.all(color: Colors.blue,width: 1.5)),
        
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FontAwesomeIcons.clock),
                            SizedBox(width: 10),
                            Text('Opening Hours',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                                    
                          ],
                        ),
                      ),
                              SizedBox(height: 10),
              Text(
                'Mon–Fri: 8am–6:30pm',
                style: TextStyle(fontSize: 20),
              ),
              Text('Sat: 9am–5pm', style: TextStyle(fontSize: 20)),
              Text('Sun: 9am–4pm', style: TextStyle(fontSize: 20)),
                    ],
                  )),
              SizedBox(height: 20),
              Container(

                  height: screenHeight * 0.35,
                width: screenWidth *0.9,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                 color: Colors.blue[100],
                border: Border.all(color: Colors.blue,width: 1.5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.mapPin),
                          SizedBox(width: 6),
                                                  Text('Address',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                            SizedBox(height: 10),
              Text(
                'GUNGAHLIN MEDICAL PRACTICE,',
                style: TextStyle(fontSize: 20),
              ),
              Text('Suite 3a -5,The Market Place,',
                  style: TextStyle(fontSize: 20)),
                  Text('30 Hibberson St,Gungahlin', style: TextStyle(fontSize: 20)),
              Text('ACT 2912, Australia.', style: TextStyle(fontSize: 20)),
              Text('Tel: 02 6255 7007', style: TextStyle(fontSize: 20)),
              Text('Fax: 02 6255 0001', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              SizedBox(height: 20),
             Text('Get Appointment',style: GoogleFonts.bebasNeue(color: Colors.black,fontSize: 30),),
              SizedBox(height: 15),
            Containers(clr: Colors.blue, txt: 'Book Appointment', onTap: (){
              Navigator.pushNamed(context, Routenames.doctorsdata);
            }),
              
       ] ),
      ),
    ));
  }
}
