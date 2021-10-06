import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/animations/custom_countup.dart';
import '../view_model.dart';
import 'package:haniwa/theme/colors.dart';

class TotalStar extends StatelessWidget {
  TotalStar({
    @required this.star,
    @required this.delay,
  });
  final int star;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final _viewModel = Provider.of<ResultViewModel>(context, listen: false);
    final _newStar = _viewModel.newStar.toDouble();
    final _pointStyle = TextStyle(
      color: Colors.amber,
      fontSize: width * 0.18,
      fontWeight: FontWeight.bold,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Total ',
          style: TextStyle(
            color: kPointColor,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: width * 0.13,
        ),
        CustomCountup(
          begin: _newStar - star,
          end: _newStar,
          delay: delay,
          duration: Duration(seconds: 1),
          style: _pointStyle,
        ),
        Text(
          '!!',
          style: TextStyle(
            color: _theme.accentColor,
            fontSize: width * 0.15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
