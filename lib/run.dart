import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'seacrets/local_ip.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

import 'pages/dev_page/index.dart';
import 'pages/signin_page/index.dart';
import 'pages/result_page/index.dart';
import 'pages/list_page/index.dart';
import 'pages/timer_page/index.dart';
import 'pages/timer_page/content.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

void run({bool isEmulator = false}) async {
  final logger = SimpleLogger();
  logger.info('start(isEmulator: $isEmulator)');
  WidgetsFlutterBinding.ensureInitialized();

  // firebase初期化
  await Firebase.initializeApp();

  // firebase_enumの分岐
  if (isEmulator) {
    FirebaseFirestore.instance.settings =
        Settings(host: '$kLocalIP:8080', sslEnabled: false);
    FirebaseAuth.instance.useEmulator('http://$kLocalIP:9099');
  }

  // タイムゾーンを初期化
  tz.initializeTimeZones();
  var tokyo = tz.getLocation('Asia/Tokyo');
  tz.setLocalLocation(tokyo);

  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //縦固定
  ]);

  // dynamicLinks
  FirebaseDynamicLinks.instance.onLink(
    onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final prefs = await SharedPreferences.getInstance();
      final currentTimer = prefs.getString(timerKey);
      _navigatePage(currentTimer, dynamicLink?.link);
    },
    onError: (OnLinkErrorException e) async {
      print('DynamiLinkエラー');
      print(e.message);
    },
  );
  await FirebaseDynamicLinks.instance.getInitialLink();

  runApp(Haniwa());
}

class Haniwa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorKey: _navigatorKey,
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      initialRoute: ListPage.id,
      routes: {
        DevPage.id: (_) => DevPage(),
        SigninPage.id: (_) => SigninPage(ListPage.id),
        ResultPage.id: (context) =>
            _routeBranch(context, ResultPage.id, ResultPage()),
        ListPage.id: (context) =>
            _routeBranch(context, ListPage.id, ListPage()),
        TimerPage.id: (context) =>
            _routeBranch(context, TimerPage.id, TimerPage()),
      },
    );
  }
}

Widget _routeBranch(BuildContext context, String id, Widget trueWidget) {
  final currentUser = FirebaseAuth.instance.currentUser;
  return (currentUser == null) ? SigninPage(id) : trueWidget;
}

void _navigatePage(String currentTimer, Uri deeplink) async {
  try {
    if (currentTimer == null) {
      if (FirebaseAuth.instance.currentUser != null) {
        // リスト画面まで戻る
        _navigatorKey.currentState.popUntil(ModalRoute.withName(ListPage.id));
        // プログレスを表示してクエストを取得
        showProgressDialog(_navigatorKey.currentContext);
        final idList = deeplink.queryParameters['id'].split('-');
        print(idList[1]);
        final _quest = await fetchTagQuest(idList[1]);
        _navigatorKey.currentState.pop();
        // 終了したらタイマー画面へプッシュ
        _navigatorKey.currentState.pushNamed(
          TimerPage.id,
          arguments: TimerArguments(quest: _quest),
        );
      } else {
        showSnackBar(_navigatorKey.currentContext, 'サインインが完了していません');
      }
    } else {
      showSnackBar(_navigatorKey.currentContext, '作業中のクエストがあります');
    }
  } catch (e) {
    print('タグ取得エラー $e');
    showSnackBar(_navigatorKey.currentContext, 'このタグを所有するグループに参加してください');
    _navigatorKey.currentState.popUntil(ModalRoute.withName(ListPage.id));
  }
}
