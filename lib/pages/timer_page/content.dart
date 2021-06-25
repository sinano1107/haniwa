import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:haniwa/components/point_text.dart';
import 'package:haniwa/common/notification.dart';
import 'package:haniwa/models/quest.dart';
import 'components/timer_app_bar.dart';
import 'components/timer.dart';
import 'view_model.dart';

class TimerPageContent extends StatefulWidget {
  @override
  _TimerPageContentState createState() => _TimerPageContentState();
}

class _TimerPageContentState extends State<TimerPageContent>
    with WidgetsBindingObserver {
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
    print(state);
    if (state == AppLifecycleState.paused) {
      // 通知を設定する
      if (_viewModel.isCounting) {
        final _time = _controller.getTime().split(':').map((t) => int.parse(t));
        print(_time);
        scheduleLocalNotification(
          Duration(minutes: _time.first, seconds: _time.last),
          '${_quest.name} をやり遂げました！🎉',
          'おつかれさま！アプリを開いて報酬を受け取りましょう！',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<TimerViewModel>(context, listen: false);
    final _height = MediaQuery.of(context).size.height;
    final _quest = _viewModel.quest;

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
}
