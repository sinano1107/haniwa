import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/providers/haniwa_provider.dart';
import 'package:haniwa/components/icon_button.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/models/trade.dart';
import 'package:haniwa/pages/trade_page/index.dart';
import 'name_input.dart';
import 'star_input.dart';

class AddTradeDialog extends StatelessWidget {
  const AddTradeDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<HaniwaProvider>(context, listen: false);
    final uid = FirebaseAuth.instance.currentUser.uid;
    String name = '';
    String star = '';

    void _onPressed() async {
      if (name.length == 0) {
        showSnackBar(context, 'なまえを入力してください');
        return;
      }
      if (star.length == 0 || star == '0') {
        showSnackBar(context, 'ひつようなスターを入力してください');
        return;
      }
      var intStar;
      try {
        intStar = int.parse(star);
      } catch (_) {
        showSnackBar(context, 'ひつようなスターに数字を入力してください');
        return;
      }
      final trade = Trade(
        id: null,
        name: name,
        star: intStar,
        isAproved: provider.admin == uid,
      );
      showProgressDialog(context);
      try {
        await TradeColFirestore(context).add(trade);
      } catch (e) {
        showSnackBar(context, 'こうかんできるものの追加に失敗しました');
        print('トレード追加エラー: $e');
      }
      Navigator.popUntil(context, ModalRoute.withName(TradePage.id));
    }

    return AlertDialog(
      title: Text('こうかんできるものを増やす'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NameInput(onChanged: (s) => name = s),
          StarInput(onChanged: (s) => star = s),
          IconButtonWidget(
            icon: Icon(Icons.create),
            text: '追加する',
            color: theme.primaryColor,
            size: Size(200, 40),
            onPressed: _onPressed,
          ),
        ],
      ),
    );
  }
}
