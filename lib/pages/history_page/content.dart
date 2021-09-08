import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:haniwa/models/history.dart';
import 'package:haniwa/theme/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HistoryPageContent extends StatelessWidget {
  const HistoryPageContent({
    Key key,
    @required this.histories,
  }) : super(key: key);
  final List<History> histories;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: histories.length > 0
            ? buildList(width)
            : [
                SizedBox(height: height * 0.05),
                Center(
                  child: Text(
                    '履歴が存在しません',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
      ),
    );
  }

  List<Widget> buildList(double width) {
    DateTime date = histories.first.time;
    List<Widget> list = [DateHeader(date: date)];
    histories.forEach((history) {
      if (!(date.difference(history.time).inDays == 0 &&
          date.day == history.time.day)) {
        // 日付が変わったのでdateを変更
        date = history.time;
        list.add(Divider());
        list.add(DateHeader(date: date));
      }
      list.add(buildHistoryTile(history, width));
    });
    return list;
  }
}

Widget buildHistoryTile(History history, double width) {
  final formatter = DateFormat('HH:mm', 'ja_JP');

  return ListTile(
    subtitle: RatingBarIndicator(
      rating: history.star.toDouble(),
      itemCount: 5,
      itemBuilder: (_, __) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemSize: width * 0.05,
      unratedColor: Colors.transparent,
    ),
    title: Text(
      history.name + 'をクリアした!',
      style: TextStyle(
        color: kPointColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    trailing: Text(
      formatter.format(history.time),
      style: TextStyle(
        color: Colors.grey,
      ),
    ),
  );
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
