import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/common/firestore.dart';
import 'report_quest_item.dart';

class QuestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: QuestColFirestore(context).snapshots(),
      builder: (context, snap) {
        if (snap.hasError) {
          return SliverList(
            delegate: SliverChildListDelegate([
              Text(
                'エラー',
                style: TextStyle(
                  color: Colors.red,
                ),
              )
            ]),
          );
        }

        if (snap.connectionState == ConnectionState.waiting) {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 50),
                Center(child: CircularProgressIndicator())
              ],
            ),
          );
        }

        final data = snap.data.docs;
        return SliverList(
          delegate: SliverChildListDelegate(_buildList(data)),
        );
      },
    );
  }

  List<Widget> _buildList(List<QueryDocumentSnapshot<Object>> data) {
    if (data.length == 0) {
      return [
        SizedBox(height: 50),
        Center(
            child: Text(
          'クエストを追加しましょう！',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        ))
      ];
    }

    // ReportQuestのリストに変換
    List<ReportQuest> quests = data.map((DocumentSnapshot docSnap) {
      final Map<String, dynamic> d = docSnap.data();
      d['id'] = docSnap.id;
      return ReportQuest.decode(d);
    }).toList();
    // 今日やるものとやらないものに分別
    final today = DateTime.now().weekday - 1;
    final List<ReportQuest> notTodays = [];
    final todays = quests.where((quest) {
      final answer = quest.workingDays.contains(today);
      if (!answer) notTodays.add(quest);
      return answer;
    }).toList();
    // 合体させてReportQuestItemに
    return (todays + notTodays)
        .map((quest) => ReportQuestItem(quest: quest))
        .toList();
  }
}
