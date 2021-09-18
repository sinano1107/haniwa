import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/models/member.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/badge.dart';
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
          future: fetchAndUpdateMyData(context, _quest, _viewModel),
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
  ResultViewModel viewModel,
) async {
  final member = await MemberFirestore(context).get();
  // ポイントを加算
  MemberFirestore(context).update({
    'star': member.star + quest.star,
  });
  // レコード(今までこなした回数)を記録
  final record = await RecordFirestore(context, quest.id).get();
  record.countInclement();
  record.continuationInclement(quest);
  record.setLast();
  viewModel.setRecord(record);
  RecordFirestore(context, quest.id).set(record);
  // 履歴を追加
  await HistoriesColFirestore(context).saveHistory(quest);
  // クエストのlastを編集
  await QuestFirestore(context, quest.id).update({
    'last': FieldValue.serverTimestamp(),
  });
  // バッジ
  QuestClearBadge(context).save();
  return member;
}

class ResultArguments {
  ResultArguments({
    @required this.quest,
  });
  final ReportQuest quest;
}
