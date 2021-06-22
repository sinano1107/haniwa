import 'package:flutter/material.dart';
import 'components/list_app_bar.dart';
import 'components/quest_list.dart';
import 'components/list_page_fab.dart';

class ListPage extends StatelessWidget {
  static const id = 'list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ListAppBar(),
          QuestList(),
          SliverList(delegate: SliverChildListDelegate([Container(height: 30)]))
        ],
      ),
      floatingActionButton: ListPageFAB(),
    );
  }
}
