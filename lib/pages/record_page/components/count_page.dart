import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/common/badge.dart';
import 'package:haniwa/theme/colors.dart';
import '../view_model.dart';
import '../index.dart';
import 'confetti_wrap.dart';

class CountPage extends StatelessWidget {
  const CountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = Provider.of<RecordViewModel>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final RecordPageArguments _args = ModalRoute.of(context).settings.arguments;
    //================================================
    final controller = ConfettiController(duration: Duration(seconds: 10));
    final target = getTarget(_args.record.count);
    final completed = target <= _args.record.count;
    bool ended = false;

    return FutureBuilder(
      future: saveBadge(context, target, _args.record.count),
      builder: (context, ss) {
        if (ss.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (ss.hasError) {
          return Center(
            child: Text('エラー'),
          );
        }
        return GestureDetector(
          onTap: () {
            if (ended) {
              viewModel.nextPage();
            }
          },
          child: Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: height * 0.1),
                    Image.asset(
                      'assets/images/times_medal/$target.png',
                      width: target >= 15 ? width * 0.8 : null,
                      height: height * 0.51,
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      getText(completed, _args, target),
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
                          if (completed) controller.play();
                        },
                      ),
                    )
                  ],
                ),
                ConfettiWrap(controller: controller),
              ],
            ),
          ),
        );
      },
    );
  }

  int getTarget(int count) {
    if (count <= 3) return 3;
    if (count <= 5) return 5;
    if (count <= 10) return 10;
    if (count <= 15) return 15;
    return 30;
  }

  String getText(bool completed, RecordPageArguments args, int target) {
    final count = completed ? args.record.count : target;
    final trailing = completed ? 'した!!' : 'する!';
    return '${args.name}を${count.toString()}回クリア$trailing';
  }

  Future saveBadge(BuildContext context, int target, int count) async {
    if (target != count) return;
    TimesMedalBadge(context).save(count);
    HaniwaMedalBadge(context).save(count);
  }
}
