import 'package:flutter/material.dart';

class CompleteCard extends StatelessWidget {
  const CompleteCard({
    Key key,
    @required this.budgeName,
  }) : super(key: key);
  final String budgeName;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: ListTile(
        leading: Text(
          '🎉',
          style: TextStyle(fontSize: width * 0.1),
        ),
        title: Text(
          '全てのバッジを取得しました！！',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: width * 0.04,
          ),
        ),
        subtitle: Text(budgeName),
      ),
    );
  }
}
