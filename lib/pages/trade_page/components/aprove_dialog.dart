import 'package:flutter/material.dart';
import 'package:haniwa/models/trade.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'name_input.dart';
import 'star_input.dart';

class AproveDialog extends StatelessWidget {
  const AproveDialog({
    Key key,
    @required this.trade,
  }) : super(key: key);
  final Trade trade;

  @override
  Widget build(BuildContext context) {
    String name = trade.name;
    String star = trade.star.toString();

    void _onPressed() async {
      Navigator.pop(context);
      showProgressDialog(context);
      try {
        await TradeFirestore(context, trade.id).update({
          'name': name,
          'star': int.parse(star),
          'isAproved': true,
        });
      } catch (e) {
        print('トレード承認エラー $e');
        showSnackBar(context, 'ほしいものの承認の失敗しました');
      }
      Navigator.pop(context);
    }

    return AlertDialog(
      title: Text('「${trade.name}」を承認しますか？'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('不満なら編集して承認できます！'),
            NameInput(
              initialValue: name,
              onChanged: (s) => name = s,
            ),
            StarInput(
              initialValue: star,
              onChanged: (s) => star = s,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _onPressed,
          child: Text(
            '承認する！',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
