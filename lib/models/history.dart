import 'package:flutter/cupertino.dart';

class History {
  History({
    @required this.id,
    @required this.name,
    @required this.star,
    @required this.time,
  });
  final String id;
  final String name;
  final int star;
  final DateTime time;

  static History decode(Map<String, dynamic> value) {
    return History(
      id: value['id'],
      name: value['name'],
      star: value['star'],
      time: value['time'].toDate(),
    );
  }
}
