import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'seacrets/local_ip.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

import 'pages/signin_page/index.dart';
import 'pages/result_page/index.dart';
import 'pages/list_page/index.dart';
import 'pages/timer_page/index.dart';

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
  runApp(Haniwa());
}

class Haniwa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      initialRoute: SigninPage.id,
      routes: {
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
