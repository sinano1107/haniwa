import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class History {
  History({
    @required this.authorId,
    @required this.text,
    @required this.time,
    this.questId,
    this.star,
    this.tradeId,
  });
  final String authorId;
  final String text;
  final String questId;
  final int star;
  final String tradeId;
  final DateTime time;

  static History decode(Map<String, dynamic> value) {
    return History(
      authorId: value['authorId'],
      text: value['text'],
      questId: value['questId'] ?? null,
      star: value['star'] ?? null,
      tradeId: value['tradeId'] ?? null,
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
    if (tradeId != null) base['tradeId'] = this.tradeId;
    return base;
  }
}
