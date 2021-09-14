import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiWrap extends StatelessWidget {
  const ConfettiWrap({
    Key key,
    @required this.controller,
    this.numberOfParticles = 15,
  }) : super(key: key);
  final ConfettiController controller;
  final int numberOfParticles;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: controller,
            blastDirection: 3 / 8 * pi,
            numberOfParticles: numberOfParticles,
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: controller,
            blastDirection: 1 / 2 * pi,
            numberOfParticles: numberOfParticles,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: controller,
            blastDirection: 5 / 8 * pi,
            numberOfParticles: numberOfParticles,
          ),
        ),
      ],
    );
  }
}
