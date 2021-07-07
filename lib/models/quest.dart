import 'package:flutter/foundation.dart';

class Quest {
  Quest({
    @required this.id,
    @required this.uid,
    @required this.name,
    @required this.minutes,
    @required this.point,
    this.subscriber,
  });
  final String id;
  final String uid;
  final String name;
  final int minutes;
  final int point;
  final String subscriber;

  Map<String, dynamic> get encode {
    return {
      'id': this.id,
      'uid': this.uid,
      'name': this.name,
      'minutes': this.minutes,
      'point': this.point,
    };
  }

  static Quest decode(Map<String, dynamic> input) {
    return Quest(
      id: input['id'],
      uid: input['uid'],
      name: input['name'],
      minutes: input['minutes'],
      point: input['point'],
    );
  }
}
