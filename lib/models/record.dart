import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:haniwa/models/report_quest.dart';

class Record {
  Record({
    @required this.count,
    @required this.continuation,
    @required this.maxContinuation,
    @required this.last,
  });
  int count;
  int continuation;
  int maxContinuation;
  DateTime last;

  void countInclement() {
    count += 1;
  }

  void continuationInclement(ReportQuest quest) {
    // 継続できているか確認する
    if (last == null) {
      // lastがnullなので初めて
      continuation = 1;
    } else if (_checkContinuation(quest)) {
      // 継続成功
      continuation += 1;
      if (maxContinuation < continuation) maxContinuation = continuation;
    } else {
      // 継続失敗
      continuation = 1;
    }
  }

  void setLast() {
    last = DateTime.now();
  }

  bool _checkContinuation(ReportQuest quest) {
    final now = DateTime.now();
    // 直前の勤務日と今日の曜日から日数の差を求める
    final today = now.weekday - 1;
    final beforeWd = quest.workingDays.reversed.firstWhere(
      (wd) => wd < today,
      orElse: () => quest.workingDays.last - 7,
    );
    final diff = today - beforeWd;
    // 今日とlastの差がそれと等しい場合継続できている
    return now.difference(last).inDays == diff;
  }

  Map<String, dynamic> get encode {
    return {
      'count': count,
      'continuation': continuation,
      'maxContinuation': maxContinuation,
      'last': last != null ? Timestamp.fromDate(last) : null,
    };
  }

  static Record decode(Map<String, dynamic> value) {
    return Record(
      count: value['count'],
      continuation: value['continuation'],
      maxContinuation: value['maxContinuation'],
      last: value['last']?.toDate(),
    );
  }
}
