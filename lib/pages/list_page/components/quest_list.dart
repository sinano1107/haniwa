import 'package:flutter/material.dart';
import 'package:haniwa/models/quest.dart';
import 'quest_list_item.dart';

class QuestList extends StatelessWidget {
  final List<Quest> questList = [
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
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
