import 'package:flutter/material.dart';
// import 'quest_list_item.dart';
// import 'package:haniwa/models/quest.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class ListAppBar extends StatelessWidget {
  ListAppBar({
    @required this.scaffoldKey,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: scaffoldKey.currentState.openDrawer,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text('クエストリスト'),
        background: Container(
          color: _theme.accentColor,
        ),
      ),
      pinned: true,
      // collapsedHeight: 100,
      expandedHeight: 100,
    );
  }
}
