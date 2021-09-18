import 'package:flutter/material.dart';

class RecordViewModel extends ChangeNotifier {
  PageController _controller = PageController();
  PageController get controller => _controller;
  // PageViewを次へ
  void nextPage() {
    controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }
}
