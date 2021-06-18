import 'package:flutter/material.dart';
import 'package:haniwa/components/icon_button.dart';
import 'components/quest_info_header.dart';
import 'components/point_text.dart';
import 'components/condition_text.dart';

class QuestInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: _theme.canvasColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          QuestInfoHeader(),
          SizedBox(height: 10),
          PointText(),
          SizedBox(height: 5),
          ConditionText(),
          SizedBox(height: 70),
          IconButtonWidget(
            icon: Icon(Icons.watch_later),
            text: '予約する',
            color: _theme.accentColor,
            fontWeight: FontWeight.bold,
            onPressed: () {},
          ),
          SizedBox(height: 20),
          IconButtonWidget(
            icon: Icon(Icons.local_fire_department),
            text: '始める',
            color: _theme.primaryColor,
            fontWeight: FontWeight.bold,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
