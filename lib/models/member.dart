import 'package:flutter/foundation.dart';

class Member {
  Member({
    @required this.uid,
    @required this.name,
    @required this.star,
  });
  final String uid;
  final String name;
  final int star;

  static Member decode(Map<String, dynamic> value) {
    return Member(
      uid: value['uid'],
      name: value['name'],
      star: value['star'],
    );
  }
}
