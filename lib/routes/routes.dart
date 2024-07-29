import 'package:clientwork/routes/routenames.dart';
import 'package:clientwork/screens/bottomnavbar.dart';
import 'package:clientwork/screens/contactus.dart';
import 'package:clientwork/screens/doctorsdata.dart';
import 'package:clientwork/screens/homescreen.dart';
import 'package:flutter/material.dart';
import '../screens/apppointments.dart';
import '../screens/splashscreen.dart';
class Routes {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routenames.contactus:
        return MaterialPageRoute(
            builder: (BuildContext context) => contactus());
            case Routenames.doctorsdata:
        return MaterialPageRoute(
            builder: (BuildContext context) => doctorsdata());
      case Routenames.homescreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => homescreen());
      case Routenames.AppointmentList:
        return MaterialPageRoute(
           builder: (context) => AppointmentList());
      case Routenames.bottomnavbar:
        return MaterialPageRoute(
            builder: (BuildContext context) => bottomnavbar());
       case Routenames.splashscreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => splashscreen(
             
            ));
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold();
        });
    }
  }
}
