import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/providers/haniwa_provider.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/pages/signin_page/index.dart';
import 'package:haniwa/pages/error_page/index.dart';
import 'package:haniwa/pages/list_page/index.dart';

class LandingPage extends StatefulWidget {
  static const id = 'landing';
  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    super.initState();
  }

  void init() async {
    // すでにログインしている場合自分のgroupIdを取得する
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final uid = currentUser.uid;
        final groupId = await UserFirestore().fetchMyGroupId();
        final groupData = await GroupFirestore(context).get();
        final haniwaProvider = Provider.of<HaniwaProvider>(
          context,
          listen: false,
        );
        // プロバイダにgroupId,groupDataを保存
        haniwaProvider.init(groupId: groupId, admin: groupData['admin']);
        // 正常に処理完了したのでリストページへ
        Navigator.pushReplacementNamed(context, ListPage.id);
      } catch (e) {
        print('user情報orグループ情報 取得エラー: $e');
        // 取得エラーしたのでエラーページへ
        Navigator.pushReplacementNamed(context, ErrorPage.id);
      }
    } else {
      // ログインされていないのでログイン画面へ
      Navigator.pushReplacementNamed(context, SigninPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('らんでぃんぐ👍'),
      ),
    );
  }
}
