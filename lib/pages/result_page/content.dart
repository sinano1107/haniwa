import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import 'package:haniwa/animations/fade_animation.dart';
import 'package:haniwa/components/cloud_storage_avatar.dart';
import './components/get_point.dart';
import './components/total_point.dart';
import './components/finish_button.dart';
import './index.dart';

class ResultPageContent extends StatelessWidget {
  final _controller = ConfettiController(duration: Duration(seconds: 10));
  final _numberOfParticles = 15;

  @override
  Widget build(BuildContext context) {
    final ResultArguments _args = ModalRoute.of(context).settings.arguments;
    final _quest = _args.quest;
    final _height = MediaQuery.of(context).size.height;
    final _delay = (500 * 8).round();
    Future.delayed(Duration(milliseconds: _delay), _controller.play);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: _height * 0.1),
                Lottie.asset('assets/lottiefiles/congratulations.json'),
              ],
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(height: _height * 0.4),
                  CloudStorageAvatar(
                    path:
                        'versions/v2/users/${FirebaseAuth.instance.currentUser.uid}/icon.png',
                    radius: 60,
                  ),
                  SizedBox(height: _height * 0.03),
                  FadeAnimation(
                    delay: 1,
                    child: GetPoint(
                      point: _quest.point,
                      delay: 1,
                    ),
                  ),
                  SizedBox(height: _height * 0.01),
                  FadeAnimation(
                    delay: 4,
                    child: TotalPoint(
                      point: _quest.point,
                      delay: 4,
                    ),
                  ),
                  SizedBox(height: _height * 0.1),
                  FadeAnimation(
                    delay: 7,
                    child: FinishButton(_quest.name),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: 3 / 8 * pi,
                numberOfParticles: _numberOfParticles,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: 1 / 2 * pi,
                numberOfParticles: _numberOfParticles,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: 5 / 8 * pi,
                numberOfParticles: _numberOfParticles,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
