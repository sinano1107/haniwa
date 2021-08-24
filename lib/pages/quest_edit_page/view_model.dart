import 'package:flutter/cupertino.dart';
import 'package:haniwa/models/quest.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/pages/list_page/index.dart';

class QuestEditViewModel extends ChangeNotifier {
  void init(Quest quest) {
    _questId = quest.id;
    _name = quest.name;
    _minutes = quest.minutes;
    _point = quest.point;
  }

  String _questId;

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

  void editQuest(BuildContext context) async {
    showProgressDialog(context);
    try {
      // await updateQuest(context, _questId, name, minutes, point);
    } catch (e) {
      print('クエスト編集エラー $e');
      showSnackBar(context, 'クエストを編集できませんでした');
    }
    Navigator.popUntil(context, ModalRoute.withName(ListPage.id));
  }
}
