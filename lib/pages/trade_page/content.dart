import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/models/trade.dart';
import 'components/trade_list_tile.dart';

class TradePageContent extends StatelessWidget {
  const TradePageContent({Key key}) : super(key: key);

  List<Widget> _buildList(List<QueryDocumentSnapshot<Object>> data) {
    if (data.length == 0) {
      return [
        SizedBox(height: 50),
        Center(
          child: Text(
            'こうかんするものを追加しましょう！',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
        ),
      ];
    }

    // Tradeにリストに変換
    List<Trade> tradeList = data.map((DocumentSnapshot ss) {
      final Map<String, dynamic> d = ss.data();
      d['id'] = ss.id;
      return Trade.decode(d);
    }).toList();
    return tradeList.map((Trade t) => TradeListTile(trade: t)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: TradeColFirestore(context).snapshots(),
      builder: (context, ss) {
        if (ss.hasError) {
          print('トレード読み込みエラー: ${ss.error}');
          return Text(
            'エラー',
            style: TextStyle(color: Colors.red),
          );
        }

        if (ss.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = ss.data.docs;
        return SingleChildScrollView(
          child: Column(
            children: _buildList(data),
          ),
        );
      },
    );
  }
}
