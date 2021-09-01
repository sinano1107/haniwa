import 'package:flutter/foundation.dart';

class Record {
  Record({
    @required this.questId,
    @required this.count,
  });
  final String questId;
  int count;

  Record inclement() {
    if (this.count >= 30) return this;
    count += 1;
    return this;
  }

  // データベースに保存する都合上questIdは除外しています
  Map<String, dynamic> get encode {
    return {
      'count': count,
    };
  }

  static Record decode(Map<String, dynamic> value) {
    return Record(
      questId: value['questId'],
      count: value['count'],
    );
  }
}
