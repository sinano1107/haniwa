import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:haniwa/models/report_quest.dart';

class Record {
  Record({
    @required this.count,
    @required this.continuation,
    @required this.maxContinuation,
  });
  int count;
  int continuation;
  int maxContinuation;

  Map<String, dynamic> get encode {
    return {
      'count': count,
      'continuation': continuation,
      'maxContinuation': maxContinuation,
    };
  }

  static Record decode(Map<String, dynamic> value) {
    return Record(
      count: value['count'],
      continuation: value['continuation'],
      maxContinuation: value['maxContinuation'],
    );
  }
}
