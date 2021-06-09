import 'package:flutter/material.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'seacrets/local_ip.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

import 'pages/signin_page/signin_page.dart';
import 'pages/home_page/home_page.dart';
import 'pages/scan_page/scan_page.dart';
import 'pages/tag_info_page/tag_info_page.dart';
import 'pages/result_page/result_page.dart';

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
  runApp(Haniwa());
}

class Haniwa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      initialRoute: HomePage.id,
      routes: {
        SigninPage.id: (_) => SigninPage(HomePage.id),
        HomePage.id: (context) =>
            _routeBranch(context, HomePage.id, HomePage()),
        ScanPage.id: (context) =>
            _routeBranch(context, ScanPage.id, ScanPage()),
        TagInfoPage.id: (context) =>
            _routeBranch(context, TagInfoPage.id, TagInfoPage()),
        ResultPage.id: (context) =>
            _routeBranch(context, ResultPage.id, ResultPage()),
      },
    );
  }
}

Widget _routeBranch(BuildContext context, String id, Widget trueWidget) {
  final currentUser = FirebaseAuth.instance.currentUser;
  return (currentUser == null) ? SigninPage(id) : trueWidget;
}
