import 'dart:convert';
import 'package:clientwork/components/button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../routes/routenames.dart';

class homescreen extends StatefulWidget {
  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  String _notificationText = '';

  @override
  void initState() {
    super.initState();
    _fetchNotificationText();
  }

  Future<void> _fetchNotificationText() async {
    try {
      final response = await http
          .get(Uri.parse('https://itjoblinks.com/public/api/notifications'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final notificationMap =
              data[0]; // Assuming there's only one notification
          if (notificationMap.containsKey('text')) {
            setState(() {
              _notificationText = notificationMap['text'];
            });
            _showNotificationDialog(); // Call the method to show the dialog
          } else {
            throw Exception('Text field not found in notification data');
          }
        } else {
          throw Exception('No notifications found in API response');
        }
      } else {
        throw Exception('Failed to load notification: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text('Homescreen', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            leading: Icon(
              FontAwesomeIcons.home,
              color: Colors.white,
            )),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 29, bottom: 7),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Our Services",
                          style: GoogleFonts.bebasNeue(
                              color: Colors.black, fontSize: 35))),
                ),
                SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600
                        ? 2
                        : 2, // Adjust based on screen widtha
                    crossAxisSpacing: screenWidth * 0.001,
                    mainAxisSpacing: screenWidth * 0.001,
                    childAspectRatio: (screenWidth > 600 ? screenWidth/ 5 : screenWidth /2 ) / (screenWidth>600?screenHeight * 0.25 : screenHeight * 0.3),
                  ),
                  itemCount: serviceCards.length,
                  itemBuilder: (context, index) {
                    final cardData = serviceCards[index];
                    return ServiceCard(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      img: cardData['img'].toString(),
                      txt1: cardData['txt1'].toString(),
                    );
                  },
                ),
                SizedBox(height: screenWidth>600?screenHeight * 0.05 : screenHeight * 0.01),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 7, left: 8, right: 8, bottom: 8),
                  child: Containers(
                      clr: Colors.blue,
                      txt: 'Book Appointment',
                      onTap: () {
                        Navigator.pushNamed(context, Routenames.doctorsdata);
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notification"),
          content: Text(
              _notificationText.isNotEmpty ? _notificationText : 'Loading...'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Continue using"),
            ),
          ],
        );
      },
    );
  }
}

class ServiceCard extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String img;
  final String txt1;

  const ServiceCard({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.img,
    required this.txt1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double containerHeight =
        screenWidth > 600 ? screenHeight * 0.5 : screenHeight * 0.2;
    double containerWidth =
        screenWidth > 600 ? screenWidth * 0.3 : screenWidth * 0.4;

    return Column(
      children: [
        Container(
          height: containerHeight,
          width: containerWidth,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 0.7,
                  blurRadius: 0.5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Opacity(
              opacity: 0.75,
              child: Image.asset(
                img,
                fit: BoxFit.cover,
                height: containerHeight,
                width: containerWidth,
              ),
            ),
          ),
        ),
        SizedBox(height: 2),
        Padding(
          padding:
              const EdgeInsets.only(left: 18.0, right: 8, top: 8, bottom: 8),
          child: Text(
            txt1,
            style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth > 600 ? 20 : 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

final List<Map<String, String>> serviceCards = [
  {'img': 'lib/assets/women.jpg', 'txt1': 'Women’s Health Services'},
  {'img': 'lib/assets/men.jpg', 'txt1': 'Men’s Health Services'},
  {'img': 'lib/assets/kid.jpg', 'txt1': 'Children’s Health Services'},
  {'img': 'lib/assets/surg.jpg', 'txt1': 'Surgical Procedures'},
];
