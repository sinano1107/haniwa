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
    final _uid = FirebaseAuth.instance.currentUser.uid;
    final _future = fetchMemberData(_uid);

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
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
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

class ResultArguments {
  ResultArguments({
    @required this.quest,
  });
  final Quest quest;
}
