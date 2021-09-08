import 'package:flutter/foundation.dart';

class QuestEditViewModel extends ChangeNotifier {
  String _name = '';
  String get name => _name;
  void editName(String value) => _name = value;

  double _star = 0;
  double get star => _star;
  void editStar(double value) => _star = value;
}
