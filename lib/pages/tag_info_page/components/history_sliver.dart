import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import './date_header.dart';
import 'history_card.dart';

class HistorySliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: DateHeader('今日'),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          HistoryCard(),
          HistoryCard(),
        ]),
      ),
    );
  }
}
