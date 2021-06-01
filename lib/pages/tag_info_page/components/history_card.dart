import 'package:flutter/material.dart';
import './history_timeline.dart';

class HistoryCard extends StatelessWidget {
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
                CircleAvatar(),
                SizedBox(width: 10),
                Text('name'),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: HistoryTimeline(
              start: DateTime(2021, 3, 1, 15, 30),
              end: DateTime(2021, 3, 1, 16, 30),
            ),
          ),
        ],
      ),
    );
  }
}
