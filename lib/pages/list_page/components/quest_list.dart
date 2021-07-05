import 'package:flutter/material.dart';
import 'package:haniwa/models/quest.dart';
import 'package:haniwa/common/firestore.dart';
import 'quest_list_item.dart';

class QuestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Quest>>(
      future: _buildList(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
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
            snap.data
                .map(
                  (q) => QuestListItem(
                    quest: q,
                    showBorder: true,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Future<List<Quest>> _buildList() async {
    return await fetchQuests();
  }
}
