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
import 'providers/cloud_storage_provider.dart';
import 'providers/user_provider.dart';
import 'models/user.dart' as user_model;

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

  runApp(Haniwa());
}

class Haniwa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<String> fetchGroupId() async {
      // すでにログインしている場合groupIdを取得する
      if (FirebaseAuth.instance.currentUser != null) {
        final doc = await FirebaseFirestore.instance
            .doc('users/${FirebaseAuth.instance.currentUser.uid}')
            .get();
        return doc['groupId'];
      } else {
        return null;
      }
    }

    return FutureBuilder<String>(
      future: fetchGroupId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // ランディングページをリターン
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        if (!snapshot.hasError) return HaniwaContent(groupId: snapshot.data);
        return MaterialApp(
          home: Text('エラー'),
        );
      },
    );
  }
}

class HaniwaContent extends StatelessWidget {
  const HaniwaContent({
    @required this.groupId,
  });
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CloudStorageProvider()),
      ],
      builder: (context, child) {
        // groupIdをuserProviderに保存
        final userProvider = Provider.of<UserProvider>(
          context,
          listen: false,
        );
        userProvider.setUser(user_model.User(groupId: groupId));
        return child;
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: _navigatorKey,
        theme: kLightTheme,
        darkTheme: kDarkTheme,
        initialRoute: ListPage.id,
        routes: {
          DevPage.id: (_) => DevPage(),
          SigninPage.id: (_) => SigninPage(),
          SelectGroupPage.id: (_) => SelectGroupPage(),
          ResultPage.id: (_) => ResultPage(),
          ListPage.id: (context) => _routeBranch(context, ListPage()),
          TimerPage.id: (_) => TimerPage(),
        },
      ),
    );
  }

  Widget _routeBranch(BuildContext context, Widget trueWidget) {
    // ログインしていなければサインインページに飛ばす
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return SigninPage();
    // groupIdがnullならセレクトグループページに飛ばす
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user.groupId == null) return SelectGroupPage();
    return trueWidget;
  }
}
