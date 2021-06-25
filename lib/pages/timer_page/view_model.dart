import 'package:flutter/foundation.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:haniwa/models/quest.dart';

class TimerViewModel extends ChangeNotifier {
  Quest _quest;
  Quest get quest => _quest;
  void setQuest(Quest newQuest) => _quest = newQuest;

  CountDownController _controller = CountDownController();
  CountDownController get controller => _controller;

  bool _isCounting = false;
  bool get isCounting => _isCounting;
  void setIsCounting(bool newValue) => _isCounting = newValue;
}
