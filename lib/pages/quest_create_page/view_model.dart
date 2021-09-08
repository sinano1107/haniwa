import 'package:flutter/cupertino.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/pages/list_page/index.dart';

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

  String _name = '';
  String get name => _name;
  void editName(String value) => _name = value;

  double _star = 1;
  double get star => _star;
  void editStar(double value) => _star = value;

  Future createQuest(BuildContext context) async {
    showProgressDialog(context);
    try {
      await QuestColFirestore(context).createQuest(name, star.toInt());
      Navigator.popUntil(context, ModalRoute.withName(ListPage.id));
    } catch (e) {
      showSnackBar(context, 'クエスト追加に失敗しました');
      print('クエスト追加エラー: $e');
      Navigator.pop(context);
    }
  }
}
