
import 'package:clientwork/providers/navprovider.dart';
import 'package:clientwork/screens/contactus.dart';
import 'package:clientwork/screens/doctorslogin.dart';
import 'package:clientwork/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'doctorsdata.dart';

class bottomnavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationControllerState(),
      child: Consumer<NavigationControllerState>(
        builder: (context, controller, _) {
          return Scaffold(
            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),
                
              ),
              child: BottomNavigationBar(
                currentIndex: controller.selectedIndex, // Use selectedIndex from controller
                onTap: (int index) {
                  controller.selectedIndex = index; // Update selected index using the controller
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.house),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.stethoscope),
                    label: 'Doctors',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.addressBook),
                    label: 'Contact',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.userDoctor),
                    label: 'Login',
                  ),
                ],
                selectedItemColor: Colors.blue, // Color for the selected icon
                unselectedItemColor: Colors.black.withOpacity(0.5), // Color for unselected icons
                backgroundColor: Colors.white, // Background color of the navigation bar
                type: BottomNavigationBarType.fixed, // Fixes the icon's position
              ),
            ),
            body: IndexedStack(
              index: controller.selectedIndex, // Access selectedIndex from the controller
              children: [
                homescreen(),
                doctorsdata(),
                contactus(),
                login(),
              ],
            ),
          );
        },
      ),
    );
  }
}
