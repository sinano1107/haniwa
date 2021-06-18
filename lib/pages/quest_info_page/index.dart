import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/models/quest.dart';
import 'content.dart';
import 'view_model.dart';

class QuestInfoPage extends StatelessWidget {
  QuestInfoPage(this.quest);
  final Quest quest;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuestInfoViewModel()),
      ],
      builder: (context, _) {
        final _viewModel = Provider.of<QuestInfoViewModel>(
          context,
          listen: false,
        );
        _viewModel.init(quest);
        return QuestInfoPageContent();
      },
    );
  }
}
