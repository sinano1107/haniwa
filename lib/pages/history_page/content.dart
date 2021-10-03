import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:haniwa/models/history/histories_wrap.dart';
import 'package:haniwa/models/history/history.dart';
import 'package:haniwa/components/cloud_storage_avatar.dart';
import 'package:haniwa/theme/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HistoryPageContent extends StatelessWidget {
  const HistoryPageContent({
    Key key,
    @required this.histories,
  }) : super(key: key);
  final List<HistoriesWrap> histories;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(children: buildList(width)),
    );
  }

  List<Widget> buildList(double width) {
    List<Widget> list = [];
    histories.forEach((hsWrap) {
      // ヘッダーの追加
      list.add(DateHeader(date: hsWrap.date));
      // 要素の追加
      hsWrap.histories
          .forEach((history) => list.add(HistoryTile(history: history)));
    });
    return list;
  }
}

final formatter = DateFormat('HH:mm', 'ja_JP');

class HistoryTile extends StatelessWidget {
  const HistoryTile({
    Key key,
    @required this.history,
  }) : super(key: key);
  final History history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isQuest = history.questId != null && history.star != null;

    return ListTile(
      leading: CloudStorageAvatar(
          path: 'versions/v2/users/${history.authorId}/icon.png'),
      title: Text(
        history.text,
        style: TextStyle(
          color: isQuest ? kPointColor : theme.accentColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: isQuest
          ? RatingBarIndicator(
              rating: history.star.toDouble(),
              itemCount: 5,
              itemBuilder: (_, __) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemSize: width * 0.05,
              unratedColor: Colors.transparent,
            )
          : null,
      trailing: Text(
        formatter.format(history.time),
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}

class DateHeader extends StatelessWidget {
  const DateHeader({
    Key key,
    @required this.date,
  }) : super(key: key);
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: height * 0.02),
        Row(
          children: [
            SizedBox(width: width * 0.03),
            Text(
              DateFormat.yMMMMEEEEd('ja').format(date),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 25,
              ),
            )
          ],
        ),
        SizedBox(height: height * 0.01),
      ],
    );
  }
}
