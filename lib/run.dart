import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'seacrets/local_ip.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';
import 'providers/haniwa_provider.dart';

import 'pages/landing_page/index.dart';
import 'pages/error_page/index.dart';
import 'pages/quest_create_page/index.dart';
import 'pages/dev_page/index.dart';
import 'pages/select_group_page/index.dart';
import 'pages/signin_page/index.dart';
import 'pages/result_page/index.dart';
import 'pages/list_page/index.dart';
import 'pages/timer_page/index.dart';

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
    FirebaseStorage.instance.useStorageEmulator(kLocalIP, 9199);
  }

  // タイムゾーンを初期化
  tz.initializeTimeZones();
  var tokyo = tz.getLocation('Asia/Tokyo');
  tz.setLocalLocation(tokyo);

  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //縦固定
  ]);

  await FirebaseDynamicLinks.instance.getInitialLink();

  // runApp(Haniwa());
  runApp(HaniwaContent());
}

class HaniwaContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HaniwaProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        navigatorKey: _navigatorKey,
        theme: kLightTheme,
        darkTheme: kDarkTheme,
        initialRoute: LandingPage.id,
        routes: {
          LandingPage.id: (_) => LandingPage(),
          ErrorPage.id: (_) => ErrorPage(),
          DevPage.id: (_) => DevPage(),
          SigninPage.id: (_) => SigninPage(),
          SelectGroupPage.id: (_) => SelectGroupPage(),
          ResultPage.id: (_) => ResultPage(),
          ListPage.id: (_) => ListPage(),
          QuestCreatePage.id: (_) => QuestCreatePage(),
          TimerPage.id: (_) => TimerPage(),
        },
      ),
    );
  }
}
