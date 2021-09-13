import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ReportQuest {
  ReportQuest({
    @required this.id,
    @required this.uid,
    @required this.name,
    @required this.star,
    @required this.workingDays,
    @required this.last,
  });
  final String id;
  final String uid;
  final String name;
  final int star;
  final List<dynamic> workingDays;
  final DateTime last;

  Map<String, dynamic> get encode {
    return {
      'id': this.id,
      'uid': this.uid,
      'name': this.name,
      'star': this.star,
      'workingDays': this.workingDays,
      'last': this.last == null ? null : Timestamp.fromDate(this.last),
    };
  }

  static ReportQuest decode(Map<String, dynamic> value) {
    return ReportQuest(
      id: value['id'],
      uid: value['uid'],
      name: value['name'],
      star: value['star'],
      workingDays: value['workingDays'],
      last: value['last']?.toDate(),
    );
  }
}
