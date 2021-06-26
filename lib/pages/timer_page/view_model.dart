import 'package:flutter/foundation.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:haniwa/models/quest.dart';

class TimerViewModel extends ChangeNotifier {
  Quest _quest;
  Quest get quest => _quest;
  void setQuest(Quest newQuest) => _quest = newQuest;

  CountDownController _controller = CountDownController();
  CountDownController get controller => _controller;

  bool _wasStart = false;
  bool get wasStart => _wasStart;
  void setWasStart(bool value) => _wasStart = value;

  bool _isCounting = false;
  bool get isCounting => _isCounting;
  void setIsCounting(bool value) => _isCounting = value;

  int _progress;
  int get progress => _progress;
  void setProgress(int value) => _progress = value;

  bool _initStart = false;
  bool get initStart => _initStart;
  void setInitStart(bool value) => _initStart = value;
}
