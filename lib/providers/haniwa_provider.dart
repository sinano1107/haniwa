import 'package:flutter/foundation.dart';

class HaniwaProvider extends ChangeNotifier {
  String _admin;
  String get admin => _admin;
  void editAdmin(String value) {
    _admin = value;
    notifyListeners();
  }
}
