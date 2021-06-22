import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/components/icon_button.dart';
import 'components/quest_info_header.dart';
import '../../components/point_text.dart';
import 'components/condition_text.dart';
import 'view_model.dart';
import 'package:haniwa/pages/timer_page/index.dart';

class QuestInfoPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<QuestInfoViewModel>(context, listen: false);
    final _theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: _theme.canvasColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          QuestInfoHeader(),
          SizedBox(height: 10),
          PointText(point: _viewModel.quest.point),
          SizedBox(height: 5),
          ConditionText(),
          SizedBox(height: 70),
          // IconButtonWidget(
          //   icon: Icon(Icons.watch_later),
          //   text: '予約する',
          //   color: _theme.accentColor,
          //   fontWeight: FontWeight.bold,
          //   onPressed: _viewModel.quest.subscriber == null ? () {} : null,
          // ),
          SizedBox(height: 20),
          IconButtonWidget(
            icon: Icon(Icons.local_fire_department),
            text: '始める',
            color: _theme.primaryColor,
            fontWeight: FontWeight.bold,
            onPressed: _startAction(context, _viewModel),
          ),
        ],
      ),
    );
  }
}

Function _startAction(BuildContext context, QuestInfoViewModel viewModel) {
  if (viewModel.quest.subscriber == null) {
    return () => Navigator.pushReplacementNamed(
          context,
          TimerPage.id,
          arguments: TimerArguments(quest: viewModel.quest),
        );
  }
  return null;
}
