import 'package:flutter/material.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/models/history/histories_wrap.dart';
import 'content.dart';

class HistoryPage extends StatelessWidget {
  static const id = 'history';
  const HistoryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<HistoriesWrap>> fetchHistory(BuildContext context) async {
      final data = await HistoriesColFirestore(context).get();
      return data.reversed.toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('クエスト達成の履歴'),
      ),
      body: FutureBuilder<List<HistoriesWrap>>(
        future: fetchHistory(context),
        builder: (context, ss) {
          if (ss.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (ss.hasError) {
            print('履歴エラー ${ss.error}');
            return Center(child: Text('エラー'));
          }
          if (ss.hasData) {
            return HistoryPageContent(histories: ss.data);
          } else {
            return Center(child: Text('データが存在しません'));
          }
        },
      ),
    );
  }
}
