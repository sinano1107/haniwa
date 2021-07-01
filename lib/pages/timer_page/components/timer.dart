import 'package:flutter/material.dart';
import 'package:haniwa/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:vibration/vibration.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/pages/result_page/index.dart';
import '../view_model.dart';

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  @override
  void initState() {
    final _viewModel = Provider.of<TimerViewModel>(context, listen: false);
    final _controller = _viewModel.controller;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_viewModel.initStart) _controller.pause();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _viewModel = Provider.of<TimerViewModel>(context, listen: false);
    final _quest = _viewModel.quest;
    final _controller = _viewModel.controller;
    int _duration = 60 * _quest.minutes;
    // _duration = 10;

    return GestureDetector(
      onTap: () => _timerControll(
        context,
        _viewModel.controller,
        _viewModel.wasStart,
        _viewModel.setWasStart,
        _viewModel.isCounting,
        _viewModel.setIsCounting,
      ),
      child: CircularCountDownTimer(
        duration: _duration,
        initialDuration: _viewModel.progress,
        controller: _controller,
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 2.8,
        ringColor: _theme.brightness == Brightness.light
            ? Colors.grey[200]
            : Colors.grey[700],
        ringGradient: null,
        fillColor: kPointColor,
        fillGradient: null,
        backgroundColor: _theme.canvasColor,
        backgroundGradient: null,
        strokeWidth: 20.0,
        strokeCap: StrokeCap.round,
        textStyle: TextStyle(
          fontSize: 60,
          color: kPointColor,
          fontWeight: FontWeight.bold,
        ),
        textFormat: CountdownTextFormat.MM_SS,
        isReverse: true,
        isReverseAnimation: false,
        isTimerTextShown: true,
        autoStart: true,
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
    );
  }

  void _timerControll(
    BuildContext context,
    CountDownController controller,
    bool wasStart,
    Function setWasStart,
    bool isCounting,
    Function setIsCounting,
  ) {
    if (!wasStart) {
      controller.start();
      setWasStart(true);
      setIsCounting(true);
      showSnackBar(context, 'タイマーをスタートしました🎉');
      _vibration();
    } else if (!isCounting) {
      controller.resume();
      setIsCounting(true);
      showSnackBar(context, 'タイマーをリスタートしました🎉');
      _vibration();
    } else {
      controller.pause();
      setIsCounting(false);
      showSnackBar(context, 'タイマーをストップしました');
      _vibration();
    }
  }

  void _vibration() async {
    final canVibrate = await Vibration.hasVibrator();
    if (canVibrate) Vibration.vibrate(duration: 500);
  }
}
