import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/models/quest.dart';
import 'view_model.dart';
import 'content.dart';

class TimerPage extends StatelessWidget {
  static const id = 'timer';

  @override
  Widget build(BuildContext context) {
    final TimerArguments _args = ModalRoute.of(context).settings.arguments;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerViewModel()),
      ],
      child: TimerPageContent(),
      builder: (context, child) {
        final _viewModel = Provider.of<TimerViewModel>(context, listen: false);
        _viewModel.setQuest(_args.quest);
        _viewModel.setProgress(_args.progress);
        if (_args.isSharedData) {
          _viewModel.setWasStart(true);
          if (_args.endTime != null) {
            // ポーズ時にタイマーが動いていた場合
            final diff = DateTime.now().difference(_args.pauseTime);
            final progress = _args.progress + diff.inSeconds;
            _viewModel.setProgress(progress);
            _viewModel.setInitStart(true);
            _viewModel.setIsCounting(true);
          }
        }
        return child;
      },
    );
  }
}

class TimerArguments {
  TimerArguments({
    @required this.quest,
    this.progress = 0,
    this.pauseTime,
    this.endTime,
    this.isSharedData = false,
  });
  final Quest quest;
  final int progress;
  final DateTime pauseTime;
  final DateTime endTime;
  final bool isSharedData;
}
