import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore.dart';
import 'package:haniwa/models/badge.dart';

String _path(BuildContext context, String name) =>
    MemberFirestore(context).path + '/badges/' + name;

class Getter {
  Getter(this.path);
  String path;

  Future<Badge> get() async {
    final then = (DocumentSnapshot ds) {
      if (ds.exists) return Badge.decode(ds.data());
      return Badge(bronzeCount: 0, silverCount: 0, goldCount: 0);
    };
    return FirebaseFirestore.instance.doc(path).get().then(then);
  }
}

Future _set(String path, Map<String, dynamic> data) async =>
    FirebaseFirestore.instance.doc(path).set(data);

// クエストを作成する 回数によってグレードアップ
class QuestCreateBadge {
  static const name = 'questCreate';
  QuestCreateBadge(this.context);
  BuildContext context;
  Future save() async {
    final path = _path(context, name);
    final badge = await Getter(path).get();
    badge.bronzeInclement(10);
    badge.silverInclement(20);
    badge.goldInclement(50);
    await _set(path, badge.encode);
  }
}

// クエストをクリアする 回数によってグレードアップ
class QuestClearBadge {
  static const name = 'questClear';
  QuestClearBadge(this.context);
  BuildContext context;
  Future save() async {
    final path = _path(context, name);
    final badge = await Getter(path).get();
    badge.bronzeInclement(10);
    badge.silverInclement(20);
    badge.goldInclement(50);
    await _set(path, badge.encode);
  }
}

// タイムズメダルをゲットする
class TimesMedalBadge {
  static const name = 'timesMedal';
  TimesMedalBadge(this.context);
  BuildContext context;
  Future save(int count) async {
    final path = _path(context, name);
    final badge = await Getter(path).get();
    switch (count) {
      case 3:
        badge.bronzeInclement(3);
        break;
      case 5:
        badge.silverInclement(4);
        break;
      case 10:
        badge.goldInclement(5);
        break;
      default:
        print('該当するグレードがありません');
    }
    await _set(path, badge.encode);
  }
}

// ハビットメダル
class HabitMedalBadge {
  static const name = 'habitMedal';
  HabitMedalBadge(this.context);
  BuildContext context;
  Future save(int count) async {
    final path = _path(context, name);
    final badge = await Getter(path).get();
    switch (count) {
      case 3:
        badge.bronzeInclement(3);
        break;
      case 5:
        badge.silverInclement(4);
        break;
      case 10:
        badge.goldInclement(5);
        break;
      default:
        print('該当するグレードがありません');
    }
    await _set(path, badge.encode);
  }
}

// ハニワメダル
// 銀2枚: 銅, 金2枚: 銀, 金5枚: 金
class HaniwaMedalBadge {
  static const name = 'haniwaMedal';
  HaniwaMedalBadge(this.context);
  BuildContext context;
  Future save(int count) async {
    final path = _path(context, name);
    final badge = await Getter(path).get();
    if (count == 15) {
      // 銀ハニワ
      badge.bronzeInclement(2);
    } else if (count == 30) {
      // 金ハニワ
      badge.silverInclement(2);
      badge.goldInclement(5);
    }
    await _set(path, badge.encode);
  }
}
