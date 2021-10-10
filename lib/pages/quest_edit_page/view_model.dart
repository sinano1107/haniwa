import 'package:flutter/foundation.dart';

class QuestEditViewModel extends ChangeNotifier {
  String _name = '';
  String get name => _name;
  void editName(String value) => _name = value;

  double _star = 0;
  double get star => _star;
  void editStar(double value) => _star = value;

  List<int> _workingDays = [];
  List<int> get workingDays => _workingDays;
  void editWorkingDays(List<int> value) {
    _workingDays = value;
    notifyListeners();
  }

  void toggleWorkingDays(int value) {
    if (_workingDays.contains(value)) {
      _workingDays.remove(value);
    } else {
      _workingDays.add(value);
    }
    notifyListeners();
  }
}
