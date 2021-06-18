import 'package:flutter/material.dart';

class PointText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 3,
                color: _theme.primaryColor,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '報酬',
                style: TextStyle(
                  color: _theme.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                thickness: 3,
                color: _theme.primaryColor,
              ),
            ),
          ],
        ),
        Text(
          '1000pt',
          style: TextStyle(
            color: _theme.primaryColor,
            fontSize: 35,
            fontWeight: FontWeight.w800,
          ),
        ),
        Divider(
          thickness: 3,
          color: _theme.primaryColor,
        ),
      ],
    );
  }
}
