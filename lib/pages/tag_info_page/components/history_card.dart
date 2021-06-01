import 'package:flutter/material.dart';
import './history_timeline.dart';
import 'package:haniwa/models/history.dart';

class HistoryCard extends StatelessWidget {
  HistoryCard(this.history);

  final History history;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(history.image),
                ),
                SizedBox(width: 10),
                Text(history.name),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: HistoryTimeline(
              start: history.start,
              end: history.end,
            ),
          ),
        ],
      ),
    );
  }
}
