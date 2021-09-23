import 'package:flutter/material.dart';
import 'components/header.dart';
import 'components/badge_card.dart';
import 'components/complete_card.dart';
import 'package:haniwa/models/badge.dart';
import 'package:haniwa/common/badge_collection.dart';

class UserPage extends StatelessWidget {
  static const id = 'user';
  const UserPage({Key key}) : super(key: key);

  // 全てのバッジを定義
  static List<Badge> badgeList = [
    questCreateBadge,
    questClearBadge,
    // questHabitBadge,
    timesMedalBadge,
    habitMedalBadge,
    timesHaniwaBadge,
    habitHaniwaBagde,
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
    if (grade == 2 && target <= progress)
      return CompleteCard(budgeName: badge.name);
    return BadgeCard(
      target: target,
      progress: progress,
      grade: grade,
      text: badge.texts[grade],
    );
  }
}
