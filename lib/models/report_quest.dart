import 'package:flutter/foundation.dart';

class ReportQuest {
  ReportQuest({
    @required this.id,
    @required this.uid,
    @required this.name,
    @required this.lebel,
    @required this.point,
  });
  final String id;
  final String uid;
  final String name;
  final double lebel;
  final int point;
}
