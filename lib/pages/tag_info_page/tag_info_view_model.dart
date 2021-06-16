import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/notification.dart';
import 'package:haniwa/models/tag.dart';
import './tag_info_page.dart';

class TagInfoViewModel extends ChangeNotifier {
  // ローカルストレージ
  static const String timerKey = 'timer';
  static const String groupTagIdKey = 'id';
  static const String elapsedTimeKey = 'elapsedTime'; // 経過時間
  static const String wasOngoingKey = 'wasOngoing'; // 終了時タイマーが継続中だったか？
  static const String endTimeKey = 'endTime'; // 継続中であればその時間(経過時間ではない)
  SharedPreferences _prefs;
  // スキャンしたタグ
  Tag _tag;
  Tag get tag => _tag;
  // 取得のエラー
  bool _isError = false;
  bool get isError => _isError;
  // カラー
  List<Color> _colors = [Colors.grey, Colors.grey];
  List<Color> get colors => _colors;
  // タイマー
  DateTime _time = DateTime(0);
  DateTime get time => _time;
  Timer _timer;
  Timer get timer => _timer;

  void init(TagInfoArguments args) async {
    _prefs = await SharedPreferences.getInstance();
    if (args.elapsedTime != null) {
      // 経過時間が保存されていたら
      final elapsedTime = DateTime.parse(args.elapsedTime);
      _time = elapsedTime;
      if (args.wasOngoing) {
        // 終了時継続中だったら
        final endTime = DateTime.parse(args.endTime);
        final diff = DateTime.now().difference(endTime);
        _time = _time.add(diff);
        toggleTimer();
      }
      _prefs.remove(timerKey);
      print('ストレージをクリアしました');
    }
  }

  final _showDialogAction = StreamController<ShowDialogEvent>();
  StreamController<ShowDialogEvent> get showDialogAction => _showDialogAction;

  final _showSnackbarAction = StreamController<ShowSnackbarEvent>();
  StreamController<ShowSnackbarEvent> get showSnackbarAction =>
      _showSnackbarAction;

  // 色を変更
  void changeColors(List<Color> newColors) {
    _colors = newColors;
    notifyListeners();
  }

  // タグの情報を取得
  dynamic fetchTagData(String groupTagId) async {
    final ids = groupTagId.split('-');
    final groupId = ids[0];
    final tagId = ids[1];
    try {
      final tag = await fetchTag(groupId, tagId);
      _tag = tag;
      notifyListeners();
    } catch (e) {
      print('エラー $e');
      _isError = true;
    }
  }

  // タイマーのスタート・ストップ
  void toggleTimer() async {
    final _branch = _timer != null && _timer.isActive;
    // navBar
    _showSnackbarAction.sink.add(ShowSnackbarEvent(
      _branch ? 'タイマーストップ！' : 'タイマースタート!',
    ));
    // バイブ
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
    // タイマー分岐
    if (_branch) {
      // タイマーが動いている時
      _timer.cancel();
      _showDialogAction.sink.add(ShowDialogEvent());
      notifyListeners();
    } else {
      // タイマーが止まっている時
      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        _time = _time.add(Duration(seconds: 1));
        notifyListeners();
      });
    }
  }

  // ポーズされた時のアクション
  void pausedAction(String groupTagId) async {
    scheduleLocalNotification(Duration(seconds: 10));
    // アプリが終了される可能性があるためローカルストレージに保存
    if (_time != DateTime(0)) {
      final elapsedTime = _time.toString();
      final wasOngoing = _timer != null && _timer.isActive;
      final endTime = wasOngoing ? DateTime.now().toString() : null;
      print('===ストレージに保存===');
      print('$groupTagIdKey: $groupTagId');
      print('$elapsedTimeKey: $elapsedTime');
      print('$wasOngoingKey: $wasOngoing');
      print('$endTimeKey: $endTime');
      print('===================');
      final data = {
        groupTagIdKey: groupTagId,
        elapsedTimeKey: elapsedTime,
        wasOngoingKey: wasOngoing,
        endTimeKey: endTime,
      };
      await _prefs.setString(timerKey, jsonEncode(data));
    }
  }

  // ポーズから復帰した時のアクション
  void resumedAction() {
    print('復帰');
    cancelLocalNotification();
    // ローカルストレージに退避させたデータを白紙に
    _prefs.remove(timerKey);
    print('ストレージをクリアしました');
  }

  @override
  void dispose() {
    _showDialogAction.close();
    _showSnackbarAction.close();
    super.dispose();
  }
}

class ShowDialogEvent {}

class ShowSnackbarEvent {
  ShowSnackbarEvent(this.text);
  final String text;
}
