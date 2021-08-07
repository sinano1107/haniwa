import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/pages/deadline_gambling_create_page/index.dart';
import 'package:haniwa/pages/signin_page/index.dart';

class DevPage extends StatefulWidget {
  static const id = 'dev';

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('開発ページ'),
      ),
      body: Column(
        children: [
          MaterialButton(
            child: Text('クエストを追加する'),
            onPressed: () => Navigator.pushNamed(
              context,
              DeadlineGamblingCreatePage.id,
            ),
          ),
          MaterialButton(
            child: Text('サインアウト'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, SigninPage.id);
            },
          ),
        ],
      ),
    );
  }
}
