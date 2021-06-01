import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:haniwa/models/history.dart';
import './date_header.dart';
import 'history_card.dart';

class HistorySliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: DateHeader('今日'),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          HistoryCard(History(
            image:
                'https://lokeshdhakar.com/projects/lightbox2/images/thumb-3.jpg',
            name: 'マサキ',
            start: DateTime(2021, 3, 1, 15),
            end: DateTime(2021, 3, 1, 15, 30),
          )),
          HistoryCard(History(
            image:
                'https://lokeshdhakar.com/projects/lightbox2/images/thumb-3.jpg',
            name: 'ナナミ',
            start: DateTime(2021, 3, 3, 10),
            end: DateTime(2021, 3, 3, 11),
          )),
        ]),
      ),
    );
  }
}
