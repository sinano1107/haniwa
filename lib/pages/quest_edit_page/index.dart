import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/models/quest.dart';
import 'view_model.dart';
import 'content.dart';

class QuestEditPage extends StatelessWidget {
  QuestEditPage(this.quest);
  final Quest quest;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuestEditViewModel()),
      ],
      child: QuestEditContent(quest),
    );
  }
}
