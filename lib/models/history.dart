import 'package:flutter/cupertino.dart';

class History {
  History({
    @required this.id,
    @required this.name,
    @required this.point,
    @required this.time,
  });
  final String id;
  final String name;
  final int point;
  final DateTime time;

  static History decode(Map<String, dynamic> value) {
    return History(
      id: value['id'],
      name: value['name'],
      point: value['point'],
      time: value['time'].toDate(),
    );
  }
}
