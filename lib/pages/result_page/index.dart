import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/models/quest.dart';
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

Future<Member> fetchAndUpdateMyData(BuildContext context, Quest quest) async {
  final uid = FirebaseAuth.instance.currentUser.uid;
  final data = await fetchMemberData(context, uid);
  await updateMyData(context, {'point': data.point + quest.point});
  return data;
}

class ResultArguments {
  ResultArguments({
    @required this.quest,
  });
  final Quest quest;
}
