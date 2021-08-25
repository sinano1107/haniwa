import 'package:flutter/cupertino.dart';
import 'package:haniwa/common/firestore.dart';

class QuestCreateViewModel extends ChangeNotifier {
  final _controller = PageController();
  PageController get controller => _controller;
  // PageViewを次へ
  void nextPage() {
    controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  // PageViewを前へ
  void previousPage() {
    controller.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  String _name;
  String get name => _name;
  void editName(String value) => _name = value;

  double _level = 2;
  double get level => _level;
  void editLevel(double value) => _level = value;

  int _point = 50;
  int get point => _point;
  void editPoint(int value) {
    _point = value;
    notifyListeners();
  }

  Future createQuest(BuildContext context) async {
    await QuestColFirestore(context).createQuest(name, level, point);
  }
}
