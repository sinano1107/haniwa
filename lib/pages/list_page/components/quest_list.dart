import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/common/firestore.dart';
import 'report_quest_item.dart';

class QuestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: streamQuests(context),
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
          delegate: SliverChildListDelegate(
            data.length == 0
                ? [
                    SizedBox(height: 50),
                    Center(
                        child: Text(
                      'クエストが存在しません',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ))
                  ]
                : data.map((DocumentSnapshot docSnap) {
                    final Map<String, dynamic> data = docSnap.data();
                    data['id'] = docSnap.id;
                    return ReportQuestItem(
                      key: UniqueKey(),
                      quest: ReportQuest.decode(data),
                    );
                  }).toList(),
          ),
        );
      },
    );
  }
}
