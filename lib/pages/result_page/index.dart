import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/providers/haniwa_provider.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/models/record.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/badge_collection.dart';
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
        return FutureBuilder<int>(
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

            return snapshot.hasData ? ResultPageContent() : Scaffold();
          },
        );
      },
    );
  }
}

Future<int> fetchAndUpdateMyData(
  BuildContext context,
  ReportQuest quest,
  ResultViewModel viewModel,
) async {
  final haniwaProvider = Provider.of<HaniwaProvider>(context, listen: false);
  final callable = FirebaseFunctions.instance.httpsCallable('questClear');
  final res = await callable.call(<String, dynamic>{
    'uid': FirebaseAuth.instance.currentUser.uid,
    'groupId': haniwaProvider.groupId,
    'questId': quest.id,
  });
  print(res.data);
  switch (res.data['result']) {
    case 'finishedNormary':
      // 正常に終了
      // バッジを加算
      await questClearBadge.save(context);
      viewModel.setNewStar(res.data['newStar']);
      final recordData = Map<String, dynamic>.from(res.data['record']);
      viewModel.setRecord(Record.decode(recordData));
      return 0;
    case 'nothingQuest':
      // クエストが存在しない
      showSnackBar(context, 'このクエストは存在しません');
      Navigator.pop(context);
      break;
    case 'notWorkingDay':
      // 今日は勤務日ではない
      showSnackBar(context, '今日はやらなくていい日です');
      Navigator.pop(context);
      break;
    case 'isCleared':
      // すでにクリアしている
      showSnackBar(context, 'すでにクリアしています');
      Navigator.pop(context);
      break;
    case 'isNotMember':
      showSnackBar(context, 'あなたはこのグループのメンバーではありません');
      Navigator.pop(context);
      break;
    default:
      showSnackBar(context, '未知のレスポンスが帰ってきました');
      Navigator.pop(context);
  }
  return null;
}

class ResultArguments {
  ResultArguments({
    @required this.quest,
  });
  final ReportQuest quest;
}
