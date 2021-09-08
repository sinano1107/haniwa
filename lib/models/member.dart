import 'package:flutter/foundation.dart';

class Member {
  Member({
    @required this.star,
  });
  final int star;

  static Member decode(Map<String, dynamic> value) {
    return Member(
      star: value['star'],
    );
  }
}
