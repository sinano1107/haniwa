import 'package:flutter/material.dart';
import 'components/header.dart';
import 'components/badge_card.dart';
import 'components/complete_card.dart';

class UserPage extends StatelessWidget {
  static const id = 'user';
  const UserPage({Key key}) : super(key: key);

  // 全てのバッジを定義
  static List<Badge> badgeList = [
    Badge(
      id: 'questCreate',
      name: 'クエスト作成',
      targets: {0: 10, 1: 20, 2: 50},
      texts: {
        0: 'クエストを10回作成する',
        1: 'クエストを20回作成する',
        2: 'クエストを50回作成する',
      },
    ),
    Badge(
      id: 'questClear',
      name: 'クエストクリア',
      targets: {0: 10, 1: 20, 2: 50},
      texts: {
        0: 'クエストを10回クリアする',
        1: 'クエストを20回クリアする',
        2: 'クエストを50回クリアする',
      },
    ),
    Badge(
      id: 'questHabit',
      name: 'クエスト継続クリア',
      targets: {0: 10, 1: 20, 2: 30},
      texts: {
        0: 'クエストを連続で10回クリアする',
        1: 'クエストを連続で20回クリアする',
        2: 'クエストを連続で30回クリアする',
      },
    ),
    Badge(
      id: 'timesMedal',
      name: 'ブルーリボンメダル',
      targets: {0: 3, 1: 5, 2: 10},
      texts: {
        0: '銅のブルーリボンメダルを3枚ゲットする',
        1: '銀のブルーリボンメダルを5枚ゲットする',
        2: '金のブルーリボンメダルを10枚ゲットする',
      },
    ),
    Badge(
      id: 'habitMedal',
      name: 'レッドリボンメダル',
      targets: {0: 3, 1: 5, 2: 10},
      texts: {
        0: '銅のレッドリボンメダルを3枚ゲットする',
        1: '銀のレッドリボンメダルを5枚ゲットする',
        2: '金のレッドリボンメダルを10枚ゲットする',
      },
    ),
    Badge(
      id: 'timesHaniwa',
      name: 'ブルーリボンハニワ',
      targets: {0: 2, 1: 2, 2: 5},
      texts: {
        0: '銀のブルーリボンハニワを2枚ゲットする',
        1: '金のブルーリボンハニワを2枚ゲットする',
        2: '金のブルーリボンハニワを5枚ゲットする',
      },
    ),
    Badge(
      id: 'habitHaniwa',
      name: 'レッドリボンハニワ',
      targets: {0: 2, 1: 2, 2: 5},
      texts: {
        0: '銀のレッドリボンハニワを2枚ゲットする',
        1: '金のレッドリボンハニワを2枚ゲットする',
        2: '金のレッドリボンハニワを5枚ゲットする',
      },
    ),
  ];
  static List<BadgeData> badgeData = [
    BadgeData(id: 'questCreate', grade: 1, progress: 5),
    BadgeData(id: 'questClear', grade: 2, progress: 10),
    BadgeData(id: 'questHabit', grade: 2, progress: 30),
    BadgeData(id: 'timesMedal', grade: 0, progress: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザー情報'),
      ),
      body: Column(children: [
        // Text('バッジ保存機構の見直し'),
        UserPageHeader(),
        Divider(),
        Expanded(
          child: ListView(
            children: badgeList.map(_buildCard).toList(),
          ),
        ),
      ]),
    );
  }

  StatelessWidget _buildCard(Badge badge) {
    final data = badgeData.firstWhere(
      (d) => d.id == badge.id,
      orElse: () => BadgeData(id: '', grade: 0, progress: 0),
    );
    final grade = data.grade;
    final target = badge.targets[data.grade];
    final progress = data.progress;
    if (grade == 2 && target == progress)
      return CompleteCard(budgeName: badge.name);
    return BadgeCard(
      target: target,
      progress: progress,
      grade: grade,
      text: badge.texts[grade],
    );
  }
}

// 下位グレードを達成しないとその上位グレードの進捗は一切進められない形を想定
// targetはデータベースのデータには組み込まないでフロントエンドで記録参照する
// targetやそのバッジの名前などはidから参照できる
class BadgeData {
  BadgeData({
    @required this.id,
    @required this.grade,
    @required this.progress,
  });
  final String id;
  final int grade;
  final int progress;
}

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
}
