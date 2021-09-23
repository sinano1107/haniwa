import 'package:flutter/material.dart';
import 'components/header.dart';
import 'components/badge_card.dart';
import 'components/complete_card.dart';
import 'package:haniwa/models/badge.dart';
import 'package:haniwa/common/badge_collection.dart';

class UserPageContent extends StatelessWidget {
  const UserPageContent({
    Key key,
    @required this.badgeData,
  }) : super(key: key);
  final List<BadgeData> badgeData;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザー情報'),
      ),
      body: Column(children: [
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
