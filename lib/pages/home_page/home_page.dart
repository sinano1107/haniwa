import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstorage/localstorage.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/notification.dart';
import 'package:haniwa/pages/scan_page/scan_page.dart';
import 'package:haniwa/pages/signin_page/signin_page.dart';

class HomePage extends StatelessWidget {
  static const id = 'home';
  final storage = LocalStorage('test_key');

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
            child: Text('通知'),
            onPressed: () => scheduleLocalNotification(Duration(seconds: 10)),
          ),
          MaterialButton(
            child: Text('ローカルストレージ保存'),
            onPressed: testSetToStorage,
          ),
          MaterialButton(
            child: Text('ローカルストレージ確認'),
            onPressed: testGetFromStorage,
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

  void testSetToStorage() {
    final now = DateTime.now();
    print(now);
    storage.setItem('test_key', now.toString());
  }

  void testGetFromStorage() {
    final value = storage.getItem('test_key');
    print(value);
  }
}
