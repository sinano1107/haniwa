import 'package:flutter/material.dart';
import 'package:haniwa/common/snackbar.dart';

class QuestCreateViewModel extends ChangeNotifier {
  final _controller = PageController();
  PageController get controller => _controller;
  // pageViewを次へ
  void nextPage() {
    controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  // pageViewを前へ
  void previousPage() {
    controller.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  String _name;
  String get name => _name;
  void editName(String value) => _name = value;

  DateTime _schedule;
  DateTime get schedule => _schedule;
  void editSchedule(DateTime value) => _schedule = value;

  int _betPoint = 0;
  int get betPoint => _betPoint;
  void editBetPoint(int value) => _betPoint = value;
  void addBetPoint(int maximum, int point, BuildContext context) {
    final newBetPoint = betPoint + point;
    if (maximum < newBetPoint) {
      _betPoint = maximum;
      showSnackBar(context, '所持ポイントの半分までしか賭けられません！');
    } else {
      _betPoint = newBetPoint;
    }
    print(betPoint);
    notifyListeners();
  }

  void removeBetPoint(int point) {
    final newBetPoint = betPoint - point;
    if (10 >= newBetPoint) {
      _betPoint = 10;
    } else {
      _betPoint = newBetPoint;
    }
    print(betPoint);
    notifyListeners();
  }
}
