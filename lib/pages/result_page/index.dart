import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/models/member.dart';
import 'package:haniwa/common/firestore.dart';
import './content.dart';
import './view_model.dart';

class ResultPage extends StatelessWidget {
  static const id = 'result';

  @override
  Widget build(BuildContext context) {
    final ResultArguments _args = ModalRoute.of(context).settings.arguments;
    final _quest = _args.quest;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResultViewModel()),
      ],
      builder: (context, _) {
        final _viewModel = Provider.of<ResultViewModel>(
          context,
          listen: false,
        );
        return FutureBuilder<Member>(
          future: fetchAndUpdateMyData(context, _quest),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Scaffold(
                body: WillPopScope(
                  onWillPop: () async => false,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              print('エラー ${snapshot.error}');
              return Center(child: Text('エラー'));
            }

            if (snapshot.hasData) {
              _viewModel.setMember(snapshot.data);
              return ResultPageContent();
            } else {
              return Center(child: Text('データが存在しません'));
            }
          },
        );
      },
    );
  }
}

// TODO ここの処理かさんでいるのでfunctionsにうつしてもいいかも recordのあたりは読み込んでアップデートだから特に
Future<Member> fetchAndUpdateMyData(
  BuildContext context,
  ReportQuest quest,
) async {
  final data = await MemberFirestore(context).fetchMyData();
  // ポイントを加算
  await MemberFirestore(context).updateMyData({
    'point': data.point + quest.point,
  });
  // レコード(今までこなした回数)を記録
  final record = await RecordFirestore(context, quest.id).get();
  RecordFirestore(context, quest.id).set(record.inclement());
  // 履歴を追加
  await HistoriesColFirestore(context).saveHistory(quest);
  // クエストのlastを編集
  await QuestFirestore(context, quest.id).updateQuest({
    'last': FieldValue.serverTimestamp(),
  });
  return data;
}

class ResultArguments {
  ResultArguments({
    @required this.quest,
  });
  final ReportQuest quest;
}
