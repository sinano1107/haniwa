import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ReportQuest {
  ReportQuest({
    @required this.id,
    @required this.uid,
    @required this.name,
    @required this.star,
    @required this.last,
  });
  final String id;
  final String uid;
  final String name;
  final int star;
  final DateTime last;

  Map<String, dynamic> get encode {
    return {
      'id': this.id,
      'uid': this.uid,
      'name': this.name,
      'star': this.star,
      'last': this.last == null ? null : Timestamp.fromDate(this.last),
    };
  }

  static ReportQuest decode(Map<String, dynamic> value) {
    return ReportQuest(
      id: value['id'],
      uid: value['uid'],
      name: value['name'],
      star: value['star'],
      last: value['last']?.toDate(),
    );
  }
}
