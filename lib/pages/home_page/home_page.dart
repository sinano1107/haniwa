import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/pages/scan_page/scan_page.dart';
import 'package:haniwa/pages/signin_page/signin_page.dart';

class HomePage extends StatelessWidget {
  static const id = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ホーム')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MaterialButton(
            child: Text('スキャン'),
            onPressed: () => Navigator.pushNamed(context, ScanPage.id),
          ),
          MaterialButton(
            child: Text('グループ作成'),
            onPressed: testCreateGroup,
          ),
          MaterialButton(
            child: Text('ログアウト'),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, SigninPage.id);
            },
          ),
        ],
      ),
    );
  }

  void testCreateGroup() async {
    try {
      await createGroup('name');
      print('作成完了');
    } catch (e) {
      print('エラー $e');
    }
  }
}
