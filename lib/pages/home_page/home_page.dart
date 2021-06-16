import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/notification.dart';
import 'package:haniwa/pages/scan_page/scan_page.dart';
import 'package:haniwa/pages/signin_page/signin_page.dart';
import 'package:haniwa/pages/tag_info_page/tag_info_view_model.dart';
import 'components/previous_task_dialog.dart';

class HomePage extends StatefulWidget {
  static const id = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences _prefs;

  void init() async {
    _prefs = await SharedPreferences.getInstance();
    final timerData = _prefs.getString(TagInfoViewModel.timerKey);
    // もしストレージに何か残っていればタイマー中に終了したということなのでタグページに遷移する
    if (timerData != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PreviousTaskDialog(timerData),
      );
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

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
