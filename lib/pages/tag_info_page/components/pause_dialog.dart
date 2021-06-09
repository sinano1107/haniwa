import 'package:flutter/material.dart';
import 'package:haniwa/pages/result_page/result_page.dart';

class PauseDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('一時停止中'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '⏰',
            style: TextStyle(fontSize: 100),
          ),
          Text(
            'タイマーを一時停止しました！\nこのまま終了しますか？',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('キャンセル'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('終了する'),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, ResultPage.id);
          },
        ),
      ],
    );
  }
}
