import 'package:flutter/cupertino.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/pages/list_page/index.dart';

class QuestCreateViewModel extends ChangeNotifier {
  String _name = '';
  String get name => _name;
  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  int _minutes = 1;
  int get minutes => _minutes;
  void setMinutes(int value) => _minutes = value;

  int _point = 50;
  int get point => _point;
  void setPoint(int value) => _point = value;

  void createNewQuest(BuildContext context) async {
    showProgressDialog(context);
    try {
      await createQuest(name, minutes, point);
    } catch (e) {
      print('クエスト作成エラー $e');
      showSnackBar(context, 'クエストを作成できませんでした');
    }
    Navigator.popUntil(context, ModalRoute.withName(ListPage.id));
  }
}
