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

  Map<String, dynamic> get encode {
    return {
      'name': this.name,
      'minutes': this.minutes,
      'point': this.point,
    };
  }

  static Quest decode(Map<String, dynamic> input) {
    return Quest(
      name: input['name'],
      minutes: input['minutes'],
      point: input['point'],
    );
  }
}
