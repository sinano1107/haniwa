import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:vibration/vibration.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/models/quest.dart';
import 'package:haniwa/pages/result_page/index.dart';
import 'package:haniwa/pages/list_page/index.dart';
import 'package:haniwa/components/point_text.dart';

class TimerPage extends StatefulWidget {
  static const id = 'timer';

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  CountDownController _controller = CountDownController();
  bool _isCounting = false;
  int _duration = 900;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _height = MediaQuery.of(context).size.height;
    final TimerArguments _args = ModalRoute.of(context).settings.arguments;
    final _quest = _args.quest;
    _duration = 60 * _quest.minutes;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _quest.name,
          style: TextStyle(
            color: _theme.textTheme.bodyText1.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: _theme.iconTheme.color),
        leading: BackButton(
          onPressed: () => _back(context),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SizedBox(height: _height * 0.1),
          Center(
            child: GestureDetector(
              onTap: () => _timerControll(context),
              child: CircularCountDownTimer(
                duration: _duration,
                initialDuration: 0,
                controller: _controller,
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.8,
                ringColor: Colors.grey[200],
                ringGradient: null,
                fillColor: _theme.primaryColor,
                fillGradient: null,
                backgroundColor: Colors.white,
                backgroundGradient: null,
                strokeWidth: 20.0,
                strokeCap: StrokeCap.round,
                textStyle: TextStyle(
                  fontSize: 60,
                  color: _theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textFormat: CountdownTextFormat.MM_SS,
                isReverse: true,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: false,
                onStart: () {
                  print('Countdown Started');
                },
                onComplete: () {
                  print('Countdown Ended');
                  Navigator.pushReplacementNamed(
                    context,
                    ResultPage.id,
                    arguments: ResultArguments(quest: _quest),
                  );
                },
              ),
            ),
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

  void _timerControll(BuildContext context) {
    final time = _controller.getTime();
    if (time == '00:00') {
      _controller.start();
      _isCounting = true;
      showSnackBar(context, 'タイマーをスタートしました🎉');
      _vibration();
    } else if (!_isCounting) {
      _controller.resume();
      _isCounting = true;
      showSnackBar(context, 'タイマーをリスタートしました🎉');
      _vibration();
    } else {
      _controller.pause();
      _isCounting = false;
      showSnackBar(context, 'タイマーをストップしました');
      _vibration();
    }
  }

  void _vibration() async {
    final canVibrate = await Vibration.hasVibrator();
    if (canVibrate) Vibration.vibrate(duration: 500);
  }

  void _back(BuildContext context) {
    final time = _controller.getTime();
    if (time != '00:00') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('作業のデータは削除されます'),
          content: Text('本当に戻りますか'),
          actions: [
            TextButton(
              child: Text(
                'キャンセル',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                '戻る',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.popUntil(
                context,
                ModalRoute.withName(ListPage.id),
              ),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.pop(context);
  }
}

class TimerArguments {
  TimerArguments({
    @required this.quest,
  });
  final Quest quest;
}
