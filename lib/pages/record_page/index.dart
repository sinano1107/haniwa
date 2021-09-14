import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:confetti/confetti.dart';
import 'package:haniwa/theme/colors.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/models/record.dart';
import 'package:haniwa/pages/list_page/index.dart';

class RecordPage extends StatelessWidget {
  static const id = 'record';
  const RecordPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final RecordArguments _args = ModalRoute.of(context).settings.arguments;
    final target = getTarget(_args.record.count);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (target == 100) {
        Navigator.popUntil(context, ModalRoute.withName(ListPage.id));
        showSnackBar(context, 'あんなことよくできたね！すごいよ！！ありがとう😊');
      }
    });
    final _controller = ConfettiController(duration: Duration(seconds: 10));
    final _numberOfParticles = 15;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    bool ended = false;
    final completed = target <= _args.record.count;

    return GestureDetector(
      onTap: () {
        if (ended) {
          Navigator.popUntil(context, ModalRoute.withName(ListPage.id));
          showSnackBar(context, 'あんなことよくできたね！すごいよ！！ありがとう😊');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: height * 0.15),
                Image.asset(
                  'assets/images/times_medal/$target.png',
                  width: target >= 15 ? width * 0.8 : null,
                  height: height * 0.51,
                ),
                SizedBox(height: height * 0.03),
                Text(
                  '${_args.name}を' +
                      (completed
                          ? _args.record.count.toString()
                          : target.toString()) +
                      '回クリア' +
                      (completed ? 'した！！' : 'する！'),
                  style: TextStyle(
                    fontSize: width * 0.06,
                    color: completed ? theme.accentColor : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                  child: LinearPercentIndicator(
                    lineHeight: 35,
                    progressColor: kPointColor,
                    percent: completed ? 1 : _args.record.count / target,
                    animation: true,
                    center: Text(
                      '${_args.record.count}/$target',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onAnimationEnd: () {
                      ended = true;
                      if (target == _args.record.count) _controller.play();
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: 3 / 8 * pi,
                numberOfParticles: _numberOfParticles,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: 1 / 2 * pi,
                numberOfParticles: _numberOfParticles,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: 5 / 8 * pi,
                numberOfParticles: _numberOfParticles,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int getTarget(int count) {
  if (count <= 3) return 3;
  if (count <= 5) return 5;
  if (count <= 10) return 10;
  if (count <= 15) return 15;
  if (count <= 30) return 30;
  return 30;
}

class RecordArguments {
  RecordArguments({
    @required this.record,
    @required this.name,
  });
  final Record record;
  final String name;
}
