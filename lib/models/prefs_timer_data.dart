import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'quest.dart';

class PrefsTimerData {
  PrefsTimerData({
    @required this.quest,
    @required this.pauseTime,
    @required this.endTime,
    @required this.progress,
  });
  final Quest quest;
  final DateTime pauseTime;
  final DateTime endTime;
  final int progress;

  Map<String, dynamic> get encode => {
        'quest': quest.encode,
        'pauseTime': pauseTime.toString(),
        'endTime': endTime != null ? endTime.toString() : null,
        'progress': this.progress,
      };

  static PrefsTimerData decode(String input) {
    final inputData = jsonDecode(input);
    final endTime = inputData['endTime'] != null
        ? DateTime.parse(inputData['endTime'])
        : null;
    return PrefsTimerData(
      quest: Quest.decode(inputData['quest']),
      pauseTime: DateTime.parse(inputData['pauseTime']),
      endTime: endTime,
      progress: inputData['progress'],
    );
  }
}
