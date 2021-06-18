import 'package:flutter/material.dart';

class ListPageFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: _theme.primaryColor,
      onPressed: () {},
    );
  }
}
