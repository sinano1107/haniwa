import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haniwa/models/quest.dart';
import 'package:haniwa/common/firestore.dart';
import 'quest_list_item.dart';

class QuestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: streamQuests(),
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

        return SliverList(
          delegate: SliverChildListDelegate(
            snap.data.docs.map((DocumentSnapshot docSnap) {
              final data = docSnap;
              return QuestListItem(
                quest: Quest(
                  id: docSnap.id,
                  uid: data['uid'],
                  name: data['name'],
                  minutes: data['minutes'],
                  point: data['point'],
                ),
                showBorder: true,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
