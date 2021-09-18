import 'package:flutter/foundation.dart';

// グレードごとにカウントを保有する
class Badge {
  Badge({
    @required this.bronzeCount,
    @required this.silverCount,
    @required this.goldCount,
  });
  int bronzeCount;
  int silverCount;
  int goldCount;

  void bronzeInclement(int target) {
    if (target <= bronzeCount) return;
    bronzeCount += 1;
    if (target <= bronzeCount) print('銅バッジゲット');
  }

  void silverInclement(int target) {
    if (target <= silverCount) return;
    silverCount += 1;
    if (target <= silverCount) print('銀バッジゲット');
  }

  void goldInclement(int target) {
    if (target <= goldCount) return;
    goldCount += 1;
    if (target <= goldCount) print('金バッジゲット');
  }

  Map<String, dynamic> get encode => {
        'bronzeCount': bronzeCount,
        'silverCount': silverCount,
        'goldCount': goldCount,
      };

  static Badge decode(Map<String, dynamic> value) {
    return Badge(
      bronzeCount: value['bronzeCount'],
      silverCount: value['silverCount'],
      goldCount: value['goldCount'],
    );
  }
}
