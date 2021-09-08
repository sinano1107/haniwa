import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/models/report_quest.dart';
import 'view_model.dart';
import 'content.dart';

class QuestEditPage extends StatelessWidget {
  const QuestEditPage({
    Key key,
    @required this.quest,
  }) : super(key: key);
  final ReportQuest quest;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuestEditViewModel()),
      ],
      builder: (context, child) {
        final viewModel = Provider.of<QuestEditViewModel>(
          context,
          listen: false,
        );
        viewModel.editName(quest.name);
        viewModel.editStar(quest.star.toDouble());
        return child;
      },
      child: QuestEditContent(quest: quest),
    );
  }
}
