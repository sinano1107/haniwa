import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class History {
  History({
    @required this.authorId,
    @required this.text,
    @required this.questId,
    @required this.star,
    @required this.time,
  });
  final String authorId;
  final String text;
  final String questId;
  final int star;
  final DateTime time;

  static History decode(Map<String, dynamic> value) {
    return History(
      authorId: value['authorId'],
      text: value['text'],
      questId: value['questId'] ?? null,
      star: value['star'] ?? null,
      time: value['time'].toDate(),
    );
  }

  Map<String, Object> encode() {
    final base = {
      'authorId': this.authorId,
      'text': this.text,
      'time': Timestamp.fromDate(this.time),
    };
    if (star != null) base['star'] = this.star;
    if (questId != null) base['questId'] = this.questId;
    return base;
  }
}
