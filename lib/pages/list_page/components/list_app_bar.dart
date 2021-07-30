import 'package:flutter/material.dart';
import 'quest_list_item.dart';
import 'package:haniwa/models/quest.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListAppBar extends StatelessWidget {
  ListAppBar({
    @required this.scaffoldKey,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;
  final recommendQuest = Quest(
    id: 'aaaaa',
    uid: FirebaseAuth.instance.currentUser.uid,
    name: '出ているものを片付ける',
    minutes: 15,
    point: 1000,
  );

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: scaffoldKey.currentState.openDrawer,
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(bottom: 10),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('おすすめのクエスト'),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: _theme.canvasColor,
                child: InkWell(
                  child: QuestListItem(
                    quest: recommendQuest,
                  ),
                ),
              ),
            ),
          ],
        ),
        background: Container(
          color: _theme.accentColor,
        ),
      ),
      pinned: true,
      collapsedHeight: 120,
      expandedHeight: 200,
    );
  }
}
