import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';
import 'package:haniwa/providers/haniwa_provider.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/pages/signin_page/index.dart';
import 'package:haniwa/pages/error_page/index.dart';
import 'package:haniwa/pages/list_page/index.dart';
import 'package:haniwa/pages/maintenance_page/index.dart';
import 'package:haniwa/pages/please_update_page.dart/index.dart';

class LandingPage extends StatefulWidget {
  static const id = 'landing';
  const LandingPage({
    Key key,
    @required this.isDeveloper,
  }) : super(key: key);
  final bool isDeveloper;

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
    final state = await FirebaseFirestore.instance.doc('data/state').get();

    // versionが指定以上か確認する
    final packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isIOS) {
      final version = packageInfo.buildNumber;
      final minVersion = state['iosMinVersion'];
      if (!checkVersion(version, minVersion)) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          PleaseUpdatePage.id,
          (route) => false,
          arguments: PleaseUpdateArguments(
            version: version,
            minVersion: minVersion,
          ),
        );
        return;
      }
    } else if (Platform.isAndroid) {
      final version = packageInfo.version;
      final minVersion = state['androidMinVersion'];
      if (!checkVersion(version, minVersion)) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          PleaseUpdatePage.id,
          (route) => false,
          arguments: PleaseUpdateArguments(
            version: version,
            minVersion: minVersion,
          ),
        );
        return;
      }
    }

    // サーバーがメンテナンス状態か確認する
    if (state['isMaintenance']) {
      if (widget.isDeveloper) {
        showSnackBar(context, 'メンテナンス中ですが、開発者のため回避します');
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MaintenancePage.id,
          (route) => false,
        );
        return;
      }
    }

    // すでにログインしている場合自分のgroupIdを取得する
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final groupId = await UserFirestore().fetchMyGroupId();
        final groupData = await GroupFirestore(context).get(groupId: groupId);
        final haniwaProvider = Provider.of<HaniwaProvider>(
          context,
          listen: false,
        );
        // プロバイダにgroupId,groupDataを保存
        haniwaProvider.init(
          groupId: groupId,
          admin: groupData['admin'],
          adminName: groupData['adminName'],
        );
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 100,
        ),
      ),
    );
  }

  bool checkVersion(String version, String threshold) {
    final vs = version.split('.');
    final ts = threshold.split('.');
    var i = 0;
    for (var v in vs) {
      final t = ts[i];
      if (int.parse(v) < int.parse(t)) return false;
      i += 1;
    }
    return true;
  }
}
