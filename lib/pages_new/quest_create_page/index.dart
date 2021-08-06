import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model.dart';
import 'content.dart';

class QuestCreatePage extends StatelessWidget {
  static const id = 'quest_create';
  const QuestCreatePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuestCreateViewModel()),
      ],
      child: QuestCreateContent(),
    );
  }
}
