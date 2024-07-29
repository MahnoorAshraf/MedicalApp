import 'dart:async';

import 'package:clientwork/screens/bottomnavbar.dart';
import 'package:flutter/material.dart';
class splashservices{
  void isLogin(BuildContext context){
   
   
    Timer(Duration(seconds: 2),() => Navigator.push(context,MaterialPageRoute(builder: (context) => bottomnavbar()))); // //add post() for post screen i.e realtime database.

    } 
  }