import 'package:flutter/cupertino.dart';
import 'package:haniwa/common/firestore.dart' as firestore;

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

  double _lebel = 2;
  double get lebel => _lebel;
  void editLebel(double value) => _lebel = value;

  int _point = 50;
  int get point => _point;
  void editPoint(int value) {
    _point = value;
    notifyListeners();
  }

  Future createQuest(BuildContext context) async {
    await firestore.createQuest(context, name, lebel, point);
  }
}
