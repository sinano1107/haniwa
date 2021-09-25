import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haniwa/common/firestore.dart';

class Badge {
  Badge({
    @required this.id,
    @required this.name,
    @required this.targets,
    @required this.texts,
  });
  final String id;
  final String name;
  final Map<int, int> targets;
  final Map<int, String> texts;

  // データベース上のパスを取得
  String _path(BuildContext context) {
    return MemberFirestore(context).path + '/badges/' + id;
  }

  // データベースからBadgeDataを取得
  Future<BadgeData> _get(String path) async {
    final then = (DocumentSnapshot ds) {
      if (ds.exists) return BadgeData.decode(ds.id, ds.data());
      return BadgeData(id: ds.id, grade: 0, progress: 0);
    };
    return FirebaseFirestore.instance.doc(path).get().then(then);
  }

  // データベースに保存
  Future _set(String path, Map<String, dynamic> data) async {
    FirebaseFirestore.instance.doc(path).set(data);
  }

  // バッジの進捗を一つ増やして保存する
  // 特定のグレードのみで発動させたい場合subjectGradeを編集する
  // たとえば現在銅バッジの場合のみ進捗を増やしたいのであれば[0]にする
  // 0:銅, 1:銀, 2:金
  Future save(
    BuildContext context, {
    List<int> subjectGrade = const [0, 1, 2],
  }) async {
    final path = _path(context);
    final data = await _get(path);
    // 対象のグレードでなければブレークする
    if (!subjectGrade.contains(data.grade)) return;
    data.inclement(targets[data.grade], context);
    await _set(path, data.encode);
  }
}

class BadgeData {
  BadgeData({
    @required this.id,
    @required this.grade,
    @required this.progress,
  });
  final String id;
  int grade;
  int progress;

  void inclement(int target, BuildContext context) {
    progress += 1;
    if (target <= progress) {
      // 目標以上に達した
      saveBadgeData(grade.toString(), context);
      if (grade != 2) {
        // 目標以上に達しグレードが最上でなければグレードを上げてプログレスを初期化する
        grade += 1;
        progress = 0;
      }
    }
  }

  // ユーザーの銅、銀、金の数を編集する
  Future saveBadgeData(String grade, BuildContext context) async {
    final store = MemberFirestore(context);
    final data = await store.get();
    final count = data.badgeCount[grade];
    data.badgeCount[grade] = count + 1;
    await store.update(data.encode);
  }

  Map<String, dynamic> get encode {
    return {
      'grade': this.grade,
      'progress': this.progress,
    };
  }

  static BadgeData decode(String id, Map<String, dynamic> value) {
    return BadgeData(
      id: id,
      grade: value['grade'],
      progress: value['progress'],
    );
  }
}
