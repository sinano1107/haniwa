import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:confetti/confetti.dart';
import 'package:haniwa/models/trade.dart';
import 'package:haniwa/providers/haniwa_provider.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'aprove_dialog.dart';
import 'edit_dialog.dart';
import 'trade_dialog.dart';

class TradeListTile extends StatelessWidget {
  const TradeListTile({
    Key key,
    @required this.trade,
    @required this.controller,
  }) : super(key: key);
  final Trade trade;
  final ConfettiController controller;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HaniwaProvider>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final uid = FirebaseAuth.instance.currentUser.uid;
    final _actions = [
      IconSlideAction(
        icon: Icons.edit,
        color: Colors.lightGreen,
        foregroundColor: Colors.white,
        onTap: () => showDialog(
          context: context,
          builder: (_) => EditDialog(trade: trade),
        ),
      ),
    ];

    List<Widget> _secondaryActions() {
      if (provider.admin != uid) return [];
      return [
        IconSlideAction(
          icon: Icons.delete,
          color: Colors.red,
          onTap: () async {
            showProgressDialog(context);
            try {
              await TradeFirestore(context, trade.id).delete();
            } catch (e) {
              print('トレード削除エラー: $e');
              showSnackBar(context, 'ほしいものの削除に失敗しました');
            }
            Navigator.pop(context);
          },
        ),
      ];
    }

    void onTap() async {
      if (provider.admin == uid && !trade.isAproved) {
        // 承認されていなくて自分が権限者の場合
        showDialog(
          context: context,
          builder: (_) => AproveDialog(trade: trade),
        );
        return;
      }
      if (!trade.isAproved) {
        // 承認されていなくて自分が権限者ではない場合
        showSnackBar(context, '${provider.adminName}に承認してもらってください');
        return;
      }
      // 承認されている場合
      showDialog(
        context: context,
        builder: (_) => TradeDialog(
          trade: trade,
          controller: controller,
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Slidable(
        actionPane: SlidableScrollActionPane(),
        actions: _actions,
        secondaryActions: _secondaryActions(),
        child: ListTile(
          tileColor: trade.isAproved ? null : Colors.grey[400],
          title: Text(
            trade.name,
            style: TextStyle(
              color: Colors.black54,
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: trade.isAproved ? null : Text('この項目は承認されていません'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
              Text(
                trade.star.toString(),
                style: TextStyle(
                  fontSize: width * 0.07,
                  color: Colors.amber,
                ),
              )
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
