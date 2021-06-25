import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:vibration/vibration.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/pages/result_page/index.dart';
import '../view_model.dart';

class Timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<TimerViewModel>(context, listen: false);
    final _quest = _viewModel.quest;
    final _controller = _viewModel.controller;
    final _setIsCounting = _viewModel.setIsCounting;
    final _theme = Theme.of(context);
    int _duration = 60 * _quest.minutes;
    _duration = 10;

    return GestureDetector(
      onTap: () => _timerControll(
        context,
        _controller,
        _viewModel.isCounting,
        _setIsCounting,
      ),
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
    );
  }

  void _timerControll(
    BuildContext context,
    CountDownController controller,
    bool isCounting,
    Function setIsCounting,
  ) {
    print('controll: $isCounting');
    final time = controller.getTime();
    if (time == '00:00') {
      controller.start();
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
