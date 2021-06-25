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
        return child;
      },
    );
  }
}

class TimerArguments {
  TimerArguments({
    @required this.quest,
  });
  final Quest quest;
}
