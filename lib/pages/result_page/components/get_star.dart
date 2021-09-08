import 'package:flutter/material.dart';
import 'package:haniwa/animations/custom_countup.dart';
import 'package:haniwa/theme/colors.dart';

class GetStar extends StatelessWidget {
  GetStar({
    @required this.star,
    @required this.delay,
  });
  final int star;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final _pointStyle = TextStyle(
      color: Colors.amber,
      fontWeight: FontWeight.bold,
      fontSize: width * 0.15,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Get ',
          style: TextStyle(
            color: kPointColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: width * 0.1,
        ),
        CustomCountup(
          begin: 0,
          end: star.toDouble(),
          delay: delay,
          duration: Duration(seconds: 1),
          style: _pointStyle,
        ),
      ],
    );
  }
}
