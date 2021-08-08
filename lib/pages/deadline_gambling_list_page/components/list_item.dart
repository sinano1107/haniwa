import 'package:flutter/material.dart';

class DeadlineGamblingListItem extends StatelessWidget {
  const DeadlineGamblingListItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final x = 12.0;

    return ListTile(
      leading: RichText(
        text: TextSpan(
          text: 'あと',
          style: TextStyle(
            color: _theme.accentColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: '2h',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      title: Text(
        '勉強をがんばる',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '+50pt',
            style: TextStyle(
              fontSize: x,
              color: Colors.red[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '-100pt',
            style: TextStyle(
              fontSize: x,
              color: Colors.blue[400],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
