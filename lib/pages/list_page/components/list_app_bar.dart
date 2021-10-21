import 'package:flutter/material.dart';
import 'package:haniwa/pages/trade_page/index.dart';

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
      actions: [
        IconButton(
          icon: Icon(Icons.storefront),
          onPressed: () => Navigator.pushNamed(context, TradePage.id),
        ),
      ],
      pinned: true,
      expandedHeight: 100,
    );
  }
}
