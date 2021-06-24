import 'package:flutter/material.dart';
import 'package:haniwa/animations/custom_countup.dart';

class TotalPoint extends StatelessWidget {
  TotalPoint({
    @required this.point,
    @required this.delay,
  });
  final int point;
  final double delay;
  final _currentPoint = 1000.0;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _pointStyle = TextStyle(
      color: _theme.primaryColor,
      fontSize: 55,
      fontWeight: FontWeight.bold,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Total ',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        CustomCountup(
          begin: _currentPoint,
          end: _currentPoint + point,
          delay: delay,
          duration: Duration(seconds: 1),
          style: _pointStyle,
        ),
        Text(
          'pt',
          style: _pointStyle,
        ),
        Text(
          '!!',
          style: TextStyle(
            color: _theme.accentColor,
            fontSize: 55,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
