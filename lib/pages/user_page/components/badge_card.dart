import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard({
    Key key,
    @required this.target,
    @required this.progress,
    @required this.grade,
    @required this.text,
  }) : super(key: key);
  final int target;
  final int progress;
  final int grade; // 0,1,2をそれぞれ銅,銀,金に対応
  final String text;
  static const mainColors = {
    0: Color.fromRGBO(227, 168, 143, 1),
    1: Color.fromRGBO(191, 191, 191, 1),
    2: Color.fromRGBO(255, 221, 58, 1),
  };
  static const subColors = {
    0: Color.fromRGBO(184, 140, 122, 1),
    1: Color.fromRGBO(156, 156, 156, 1),
    2: Color.fromRGBO(220, 185, 132, 1),
  };

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: 20,
        ),
        child: Row(
          children: [
            CircularPercentIndicator(
              lineWidth: 6,
              radius: width * 0.15,
              percent: progress / target,
              progressColor: mainColors[grade],
              backgroundColor: Colors.grey[200],
              circularStrokeCap: CircularStrokeCap.round,
              center: Text(
                '$progress/$target',
                style: TextStyle(
                  color: subColors[grade],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: width * 0.04),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.04,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
