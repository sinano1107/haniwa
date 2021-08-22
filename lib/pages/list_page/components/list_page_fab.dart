import 'package:flutter/material.dart';
import 'package:haniwa/pages/quest_create_page/index.dart';

class ListPageFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: _theme.primaryColor,
      onPressed: () => Navigator.pushNamed(
        context,
        QuestCreatePage.id,
      ),
    );
  }
}
