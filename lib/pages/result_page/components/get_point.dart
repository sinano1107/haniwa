import 'package:flutter/material.dart';
import 'package:haniwa/animations/custom_countup.dart';

class GetPoint extends StatelessWidget {
  GetPoint({@required this.delay});
  final double delay;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _pointStyle = TextStyle(
      color: _theme.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 50,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Get ',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        CustomCountup(
          begin: 0,
          end: 100,
          delay: delay,
          duration: Duration(seconds: 1),
          style: _pointStyle,
        ),
        Text(
          'pt',
          style: _pointStyle,
        ),
      ],
    );
  }
}
