import 'package:flutter/material.dart';
import 'package:haniwa/components/icon_button.dart';

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
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  'お皿洗い',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 3,
                  color: _theme.primaryColor,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '報酬',
                  style: TextStyle(
                    color: _theme.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 3,
                  color: _theme.primaryColor,
                ),
              ),
            ],
          ),
          Text(
            '1000pt',
            style: TextStyle(
              color: _theme.primaryColor,
              fontSize: 35,
              fontWeight: FontWeight.w800,
            ),
          ),
          Divider(
            thickness: 3,
            color: _theme.primaryColor,
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '成功条件:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    '15分がんばる',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
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
