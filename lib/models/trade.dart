import 'package:flutter/foundation.dart';

class Trade {
  Trade({
    @required this.id,
    @required this.name,
    @required this.star,
    @required this.isAproved,
  });
  final String id;
  final String name;
  final int star;
  final bool isAproved;

  Map<String, dynamic> get encode {
    return {
      'name': this.name,
      'star': this.star,
      'isAproved': this.isAproved,
    };
  }

  static Trade decode(Map<String, dynamic> input) {
    return Trade(
      id: input['id'],
      name: input['name'],
      star: input['star'],
      isAproved: input['isAproved'],
    );
  }
}
