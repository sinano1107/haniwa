import 'package:flutter/material.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/badge.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/pages/list_page/index.dart';
import 'package:haniwa/components/icon_button.dart';

class QuestCreateViewModel extends ChangeNotifier {
  Future init(BuildContext context) async {
    // final user = await MemberFirestore(context).get();
    // if (user.star <= 4) {
    //   _controller = PageController(initialPage: 1);
    // }
    _controller = PageController(initialPage: 1);
  }

  PageController _controller = PageController();
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

  bool _isUrgent;
  void editIsUrgent(bool value) => _isUrgent = value;
  Widget previousBranchButton(BuildContext context) {
    if (_isUrgent == null) return null;
    return IconButtonWidget(
      text: '「${_isUrgent ? '緊急クエスト' : '通常のクエスト'}」を変更する',
      color: Colors.grey,
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        FocusScope.of(context).unfocus();
        _controller.jumpToPage(0);
      },
      size: Size(0, 40),
    );
  }

  String _name = '';
  String get name => _name;
  void editName(String value) => _name = value;

  double _star = 1;
  double get star => _star;
  void editStar(double value) => _star = value;

  List<int> _workingDays = [0, 1, 2, 3, 4, 5, 6];
  List<int> get workingDays => _workingDays;
  void toggleWorkingDays(int value) {
    if (_workingDays.contains(value)) {
      _workingDays.remove(value);
    } else {
      _workingDays.add(value);
    }
    notifyListeners();
  }

  Future createQuest(BuildContext context) async {
    showProgressDialog(context);
    try {
      _workingDays.sort();
      await QuestColFirestore(context).createQuest(
        name,
        star.toInt(),
        _workingDays,
      );
      await QuestCreateBadge(context).save();
      Navigator.popUntil(context, ModalRoute.withName(ListPage.id));
    } catch (e) {
      showSnackBar(context, 'クエスト追加に失敗しました');
      print('クエスト追加エラー: $e');
      Navigator.pop(context);
    }
  }
}
