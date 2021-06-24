import 'package:flutter/material.dart';
import 'package:haniwa/models/quest.dart';
import 'quest_list_item.dart';

class QuestList extends StatelessWidget {
  final List<Quest> questList = [
    Quest(
      name: '洗濯物をたたむ',
      minutes: 10,
      point: 500,
    ),
    Quest(
      name: '掃除機 下の階',
      minutes: 7,
      point: 100,
    ),
    Quest(
      name: '掃除機 上の階',
      minutes: 10,
      point: 100,
    ),
    Quest(
      name: 'ゴミ出し',
      minutes: 15,
      point: 200,
    ),
    Quest(
      name: '食器洗い',
      minutes: 30,
      point: 500,
    ),
    Quest(
      name: 'アイロン',
      minutes: 15,
      point: 200,
    ),
    Quest(
      name: 'トイレ 便器の中',
      minutes: 10,
      point: 1000,
    ),
    Quest(
      name: 'トイレ　床',
      minutes: 5,
      point: 500,
    ),
    Quest(
      name: '床拭き',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'テーブル',
      minutes: 10,
      point: 500,
    ),
    Quest(
      name: 'たな・ドア 拭き掃除',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: '出ているものを片付ける',
      minutes: 15,
      point: 1000,
    ),
    Quest(
      name: 'お風呂 洗って沸かす',
      minutes: 15,
      point: 200,
    ),
    Quest(
      name: 'お風呂 床壁掃除 片付け',
      minutes: 10,
      point: 300,
    ),
    Quest(
      name: '冷蔵庫 片付け・掃除',
      minutes: 15,
      point: 300,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        questList
            .map(
              (q) => QuestListItem(
                quest: q,
                showBorder: true,
              ),
            )
            .toList(),
      ),
    );
  }
}
