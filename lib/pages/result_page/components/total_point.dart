import 'package:flutter/material.dart';
import 'package:haniwa/animations/custom_countup.dart';

class TotalPoint extends StatelessWidget {
  TotalPoint({@required this.delay});
  final double delay;

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
          begin: 1000,
          end: 1100,
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

    return RichText(
      text: TextSpan(
        text: 'Total ',
        style: TextStyle(
          color: Colors.amber,
          fontWeight: FontWeight.bold,
          fontSize: 35,
        ),
        children: [
          TextSpan(
            text: '1100pt',
            style: TextStyle(
              color: _theme.primaryColor,
              fontSize: 55,
            ),
            children: [
              TextSpan(
                text: '!!',
                style: TextStyle(color: _theme.accentColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
