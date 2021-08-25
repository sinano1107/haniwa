import 'package:flutter/foundation.dart';

class Member {
  Member({
    @required this.point,
  });
  final int point;

  static Member decode(Map<String, dynamic> value) {
    return Member(
      point: value['point'],
    );
  }
}
