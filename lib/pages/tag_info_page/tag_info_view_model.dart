import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/models/tag.dart';

class TagInfoViewModel extends ChangeNotifier {
  Tag _tag;
  Tag get tag => _tag;

  bool _isError = false;
  bool get isError => _isError;

  List<Color> _colors = [Colors.grey, Colors.grey];
  List<Color> get colors => _colors;

  DateTime _time = DateTime(0);
  DateTime get time => _time;
  Timer _timer;
  Timer get timer => _timer;

  final _showDialogAction = StreamController<ShowDialogEvent>();
  StreamController<ShowDialogEvent> get showDialogAction => _showDialogAction;

  final _showSnackbarAction = StreamController<ShowSnackbarEvent>();
  StreamController<ShowSnackbarEvent> get showSnackbarAction =>
      _showSnackbarAction;

  void changeColors(List<Color> newColors) {
    _colors = newColors;
    notifyListeners();
  }

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
      _timer.cancel();
      _showDialogAction.sink.add(ShowDialogEvent());
      notifyListeners();
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        _time = _time.add(Duration(seconds: 1));
        notifyListeners();
      });
    }
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
