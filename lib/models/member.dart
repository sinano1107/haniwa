import 'package:flutter/foundation.dart';

class Member {
  Member({
    @required this.uid,
    @required this.name,
    @required this.star,
    @required this.badgeCount,
  });
  final String uid;
  final String name;
  final int star;
  final Map<String, dynamic> badgeCount;

  Map<String, Object> get encode {
    return {
      'name': this.name,
      'star': this.star,
      'badgeCount': this.badgeCount,
    };
  }

  static Member decode(Map<String, dynamic> value) {
    return Member(
      uid: value['uid'],
      name: value['name'],
      star: value['star'] ?? 0,
      badgeCount: value['badgeCount'] ?? {'0': 0, '1': 0, '2': 0},
    );
  }
}
