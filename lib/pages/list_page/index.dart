import 'package:flutter/material.dart';
import 'components/list_app_bar.dart';
import 'components/quest_list.dart';
import 'components/menu.dart';
// import 'components/list_page_fab.dart';

class ListPage extends StatelessWidget {
  static const id = 'list';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: [
          ListAppBar(
            scaffoldKey: _scaffoldKey,
          ),
          QuestList(),
          SliverList(delegate: SliverChildListDelegate([Container(height: 30)]))
        ],
      ),
      drawer: Menu(),
      // floatingActionButton: ListPageFAB(),
    );
  }
}
