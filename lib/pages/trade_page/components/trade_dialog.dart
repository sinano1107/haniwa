import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';
import 'package:haniwa/providers/haniwa_provider.dart';
import 'package:haniwa/models/trade.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/models/history/history.dart';
import 'package:haniwa/pages/trade_page/index.dart';

class TradeDialog extends StatelessWidget {
  const TradeDialog({Key key, @required this.trade, @required this.controller})
      : super(key: key);
  final Trade trade;
  final ConfettiController controller;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HaniwaProvider>(context, listen: false);

    return AlertDialog(
      title: Text('${trade.name}をこうかんする'),
      content: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '${trade.star}スター',
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          TextSpan(
            text: 'を支払います。\nよろしいですか？',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ]),
      ),
      actions: [
        TextButton(
          child: Text(
            'こうかんする！',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            showProgressDialog(context);
            try {
              final member = await MemberFirestore(context).get();
              if (trade.star > member.star) {
                showSnackBar(context, 'スターが足りません');
                return;
              }
              // 正常処理
              // スターを減らす
              final s = MemberFirestore(context).update({
                'star': member.star - trade.star,
              });
              // 履歴に追加
              final h = HistoriesColFirestore(context).saveHistory(History(
                authorId: FirebaseAuth.instance.currentUser.uid,
                text: '${trade.name}をこうかんしました！',
                time: DateTime.now(),
                tradeId: trade.id,
              ));
              await Future.wait([s, h]);
              showSnackBar(
                context,
                '${provider.adminName}から${trade.name}を受け取りましょう🎉',
              );
              controller.play();
            } catch (e) {
              print('こうかんエラー: $e');
              showSnackBar(context, 'こうかんに失敗しました');
            } finally {
              Navigator.popUntil(context, ModalRoute.withName(TradePage.id));
            }
          },
        ),
      ],
    );
  }
}
