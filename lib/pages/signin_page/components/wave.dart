import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class Wave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        durations: [14000, 13500, 13000],
        heightPercentages: [0.16, 0.19, 0.22],
        colors: [
          Colors.amber[100],
          Colors.amber[300],
          Colors.pink[400],
        ],
      ),
      size: Size(double.infinity, double.infinity),
    );
  }
}
