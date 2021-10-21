import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/providers/haniwa_provider.dart';
import 'package:haniwa/models/trade.dart';
import 'package:haniwa/components/icon_button.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/pages/trade_page/index.dart';
import 'name_input.dart';
import 'star_input.dart';

class EditDialog extends StatelessWidget {
  const EditDialog({
    Key key,
    @required this.trade,
  }) : super(key: key);
  final Trade trade;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HaniwaProvider>(context, listen: false);
    final uid = FirebaseAuth.instance.currentUser.uid;
    String name = trade.name;
    String star = trade.star.toString();

    void _onPressed() async {
      if (name == trade.name && star == trade.star.toString()) {
        showSnackBar(context, '変更されていません');
        return;
      } else if (name.length == 0) {
        showSnackBar(context, 'なまえを入力してください');
        return;
      } else if (star.length == 0 || star == '0') {
        showSnackBar(context, 'ひつようなスターを入力してください');
        return;
      }
      int intStar;
      try {
        intStar = int.parse(star);
      } catch (_) {
        showSnackBar(context, 'ひつようなスターに数字を入力してください');
        return;
      }
      showProgressDialog(context);
      try {
        await TradeFirestore(context, trade.id).update({
          'name': name,
          'star': intStar,
          'isAproved': provider.admin == uid,
        });
      } catch (e) {
        showSnackBar(context, 'こうかんできるものの編集に失敗しました');
        print('トレード編集エラー: $e');
      }
      Navigator.popUntil(context, ModalRoute.withName(TradePage.id));
    }

    return AlertDialog(
      title: Text('ほしいものを編集する'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NameInput(initialValue: name, onChanged: (s) => name = s),
          StarInput(initialValue: star, onChanged: (s) => star = s),
          IconButtonWidget(
            icon: Icon(Icons.edit),
            text: '編集する',
            color: Colors.lightGreen,
            size: Size(200, 40),
            onPressed: _onPressed,
          ),
        ],
      ),
    );
  }
}
