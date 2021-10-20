import 'package:flutter/material.dart';
import 'components/add_trade_dialog.dart';
import 'content.dart';

class TradePage extends StatelessWidget {
  static const id = 'trade';
  const TradePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('こうかんする'),
      ),
      body: TradePageContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddTradeDialog(),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
