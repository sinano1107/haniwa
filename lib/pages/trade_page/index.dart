import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'components/add_trade_dialog.dart';
import 'package:haniwa/pages/history_page/index.dart';
import 'content.dart';
import 'view_model.dart';

class TradePage extends StatelessWidget {
  static const id = 'trade';
  const TradePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfettiController controller = ConfettiController(
      duration: Duration(seconds: 5),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TradeViewModel()),
      ],
      builder: (context, child) {
        final viewModel = Provider.of<TradeViewModel>(context, listen: false);
        controller = viewModel.controller;
        return child;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('こうかんする'),
              actions: [
                IconButton(
                  icon: Icon(Icons.history),
                  onPressed: () => Navigator.pushNamed(context, HistoryPage.id),
                ),
              ],
            ),
            body: TradePageContent(controller: controller),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AddTradeDialog(),
              ),
              child: Icon(Icons.add),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: controller,
              blastDirection: 3 / 8 * pi,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: controller,
              blastDirection: 1 / 2 * pi,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: controller,
              blastDirection: 5 / 8 * pi,
            ),
          ),
        ],
      ),
    );
  }
}
