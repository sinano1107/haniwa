import 'package:flutter/material.dart';
import 'package:haniwa/common/auth.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/pages/landing_page/index.dart';

class ErrorPage extends StatelessWidget {
  static const id = 'error';
  const ErrorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('申し訳ありません: エラーが発生しました'),
          Text('下のボタンを押してリスタートしてください'),
          MaterialButton(
            child: Text('リスタート'),
            onPressed: () async {
              showProgressDialog(context);
              await signOut(context);
              Navigator.pushReplacementNamed(context, LandingPage.id);
            },
          ),
        ],
      ),
    );
  }
}
