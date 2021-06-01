import 'package:flutter/cupertino.dart';

class History {
  History({
    @required this.image,
    @required this.name,
    @required this.start,
    @required this.end,
  });
  final String image;
  final String name;
  final DateTime start;
  final DateTime end;
}
