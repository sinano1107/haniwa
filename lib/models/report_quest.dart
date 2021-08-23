import 'package:flutter/foundation.dart';

class ReportQuest {
  ReportQuest({
    @required this.id,
    @required this.uid,
    @required this.name,
    @required this.level,
    @required this.point,
  });
  final String id;
  final String uid;
  final String name;
  final double level;
  final int point;

  Map<String, dynamic> get encode {
    return {
      'id': this.id,
      'uid': this.uid,
      'name': this.name,
      'level': this.level,
      'point': this.point,
    };
  }

  static ReportQuest decode(Map<String, dynamic> value) {
    return ReportQuest(
      id: value['id'],
      uid: value['uid'],
      name: value['name'],
      level: value['level'],
      point: value['point'],
    );
  }
}
