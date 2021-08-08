import 'package:flutter/material.dart';
import './list_item.dart';

class ListAppBar extends StatelessWidget {
  const ListAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {},
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(bottom: 10),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ギャンブルリスト',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: _theme.canvasColor,
                child: InkWell(
                  child: DeadlineGamblingListItem(),
                ),
              ),
            ),
          ],
        ),
      ),
      pinned: true,
      collapsedHeight: 120,
      expandedHeight: 200,
    );
  }
}
