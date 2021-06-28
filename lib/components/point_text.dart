import 'package:flutter/material.dart';
import 'package:haniwa/theme/colors.dart';

class PointText extends StatelessWidget {
  PointText({
    @required this.point,
    this.thickness = 3,
  });
  final int point;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                thickness: thickness,
                color: kPointColor,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '報酬',
                style: TextStyle(
                  color: kPointColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                thickness: thickness,
                color: kPointColor,
              ),
            ),
          ],
        ),
        Text(
          '${point}pt',
          style: TextStyle(
            color: kPointColor,
            fontSize: 35,
            fontWeight: FontWeight.w800,
          ),
        ),
        Divider(
          thickness: thickness,
          color: kPointColor,
        ),
      ],
    );
  }
}
