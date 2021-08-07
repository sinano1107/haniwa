import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haniwa/common/snackbar.dart';

class DeadlineGamblingCreateViewModel extends ChangeNotifier {
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

  DateTime _deadline;
  DateTime get deadline => _deadline;
  void editDeadline(DateTime value) => _deadline = value;

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
    notifyListeners();
  }

  void removeBetPoint(int point) {
    final newBetPoint = betPoint - point;
    if (10 >= newBetPoint) {
      _betPoint = 10;
    } else {
      _betPoint = newBetPoint;
    }
    notifyListeners();
  }

  // firestoreへ保存
  Future createDeadlineGambling(int deadlineNoticeId, int soonNoticeId) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final path = 'users/$uid/deadline_gamblings';
    await FirebaseFirestore.instance.collection(path).add({
      'name': _name,
      'deadline': Timestamp.fromDate(_deadline),
      'bet_point': _betPoint,
      'deadline_notice_id': deadlineNoticeId,
      'soon_notice_id': soonNoticeId,
    });
  }
}
