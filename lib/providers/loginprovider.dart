import 'package:flutter/material.dart';

class LoginState extends ChangeNotifier {
 String? _token;
  String email = '';
  String password = '';

  String? get token => _token;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }
}
