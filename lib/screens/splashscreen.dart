
import 'package:flutter/material.dart';

import '../components/splashservices.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}
class _splashscreenState extends State<splashscreen> {
  splashservices splashScreen = splashservices();
  @override
  void initState() {
  
    // TODO: implement initState
    super.initState();
      splashScreen.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body:Center(child: 
    Image.asset('lib/assets/newlogo.png',
    fit:BoxFit.cover
    ))
    );
  }
}