import 'history.dart';

class HistoriesWrap {
  HistoriesWrap(this.histories);
  final List<History> histories;

  DateTime get date => histories[0].time;
}
