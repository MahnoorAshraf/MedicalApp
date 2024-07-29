import 'package:flutter/material.dart';
class SelectedIndexProvider with ChangeNotifier {
  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;
  void selectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}