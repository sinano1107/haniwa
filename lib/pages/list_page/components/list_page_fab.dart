import 'package:flutter/material.dart';
import 'package:haniwa/pages/quest_create_page/index.dart';

class ListPageFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: _theme.primaryColor,
      onPressed: () => _showCreatePage(context),
    );
  }
}

void _showCreatePage(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: QuestCreatePage(),
      ),
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
