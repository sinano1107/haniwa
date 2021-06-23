import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { opacity, translateX }

final tween = TimelineTween<AniProps>()
  ..addScene(begin: 0.milliseconds, duration: 500.milliseconds)
      .animate(AniProps.opacity, tween: 0.0.tweenTo(1.0))
      .animate(
        AniProps.translateX,
        tween: (-120.0).tweenTo(0),
        curve: Curves.easeOut,
      );

class FadeAnimation extends StatelessWidget {
  FadeAnimation({
    @required this.delay,
    @required this.child,
  });
  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PlayAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) {
        return Opacity(
          opacity: value.get(AniProps.opacity),
          child: Transform.translate(
            offset: Offset(value.get(AniProps.translateX), 0),
            child: child,
          ),
        );
      },
    );
  }
}
