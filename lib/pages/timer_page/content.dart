import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:haniwa/components/point_text.dart';
import 'package:haniwa/common/notification.dart';
import 'package:haniwa/models/quest.dart';
import 'package:haniwa/models/prefs_timer_data.dart';
import 'components/timer_app_bar.dart';
import 'components/timer.dart';
import 'view_model.dart';

const timerKey = 'timer';

class TimerPageContent extends StatefulWidget {
  @override
  _TimerPageContentState createState() => _TimerPageContentState();
}

class _TimerPageContentState extends State<TimerPageContent>
    with WidgetsBindingObserver {
  SharedPreferences _prefs;
  TimerViewModel _viewModel;
  Quest _quest;
  CountDownController _controller;

  @override
  void initState() {
    // バックグラウンド化イベントをリッスン
    WidgetsBinding.instance.addObserver(this);
    _viewModel = Provider.of<TimerViewModel>(context, listen: false);
    _quest = _viewModel.quest;
    _controller = _viewModel.controller;
    init();
    super.initState();
  }

  @override
  void dispose() {
    // バックグラウンド化イベントをクローズ
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // 今の経過時間
      final _time = _controller.getTime().split(':').map((t) => int.parse(t));
      final duration = Duration(minutes: _time.first, seconds: _time.last);
      // 復元用データの保存
      saveData(Duration(minutes: _quest.minutes), duration);
      // カウント中だった場合通知を設定する
      if (_viewModel.isCounting) {
        scheduleLocalNotification(
          duration,
          '${_quest.name} をやり遂げました！🎉',
          'おつかれさま！アプリを開いて報酬を受け取りましょう！',
        );
      }
    } else if (state == AppLifecycleState.resumed) {
      // 復活したので通知とprefsのデータを削除する
      cancelLocalNotification();
      _prefs.remove(timerKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: TimerAppBar(),
      ),
      body: Column(
        children: [
          SizedBox(height: _height * 0.1),
          Center(
            child: Timer(),
          ),
          SizedBox(height: _height * 0.1),
          PointText(
            point: _quest.point,
            thickness: 6,
          ),
          SizedBox(height: _height * 0.05),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              '${_quest.minutes}分間がんばれ！👍',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void saveData(Duration all, Duration duration) {
    final _data = PrefsTimerData(
      quest: _quest,
      pauseTime: DateTime.now(),
      endTime: _viewModel.isCounting ? DateTime.now().add(duration) : null,
      progress: all.inSeconds - duration.inSeconds,
    );
    _prefs.setString(timerKey, jsonEncode(_data.encode));
  }
}
