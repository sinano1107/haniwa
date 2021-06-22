import 'package:flutter/material.dart';

class PointText extends StatelessWidget {
  PointText({
    @required this.point,
    this.thickness = 3,
  });
  final int point;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                thickness: thickness,
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
                thickness: thickness,
                color: _theme.primaryColor,
              ),
            ),
          ],
        ),
        Text(
          '${point}pt',
          style: TextStyle(
            color: _theme.primaryColor,
            fontSize: 35,
            fontWeight: FontWeight.w800,
          ),
        ),
        Divider(
          thickness: thickness,
          color: _theme.primaryColor,
        ),
      ],
    );
  }
}
