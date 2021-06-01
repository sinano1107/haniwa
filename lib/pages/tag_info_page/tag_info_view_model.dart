import 'package:flutter/material.dart';

class TagInfoViewModel extends ChangeNotifier {
  List<Color> _colors = [Colors.grey, Colors.grey];
  List<Color> get colors => _colors;

  void changeColors(List<Color> newColors) {
    _colors = newColors;
    notifyListeners();
  }
}
