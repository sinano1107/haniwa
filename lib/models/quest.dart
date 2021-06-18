import 'package:flutter/foundation.dart';

class Quest {
  Quest({
    @required this.name,
    @required this.minutes,
    @required this.point,
    this.subscriber,
  });
  final String name;
  final int minutes;
  final int point;
  final String subscriber;
}
