import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ReportQuest {
  ReportQuest({
    @required this.id,
    @required this.uid,
    @required this.name,
    @required this.level,
    @required this.point,
    @required this.last,
  });
  final String id;
  final String uid;
  final String name;
  final double level;
  final int point;
  final DateTime last;

  // TODO クエストのlastが書き換えられた際にNFCは変更されないのでFunctionで観測する
  Map<String, dynamic> get encode {
    return {
      'id': this.id,
      'uid': this.uid,
      'name': this.name,
      'level': this.level,
      'point': this.point,
      'last': this.last == null ? null : Timestamp.fromDate(this.last),
    };
  }

  static ReportQuest decode(Map<String, dynamic> value) {
    return ReportQuest(
      id: value['id'],
      uid: value['uid'],
      name: value['name'],
      level: value['level'],
      point: value['point'],
      last: value['last']?.toDate(),
    );
  }
}
