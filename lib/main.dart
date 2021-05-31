import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

import 'pages/signin_page/signin_page.dart';
import 'pages/home_page/home_page.dart';
import 'pages/scan_page/scan_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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
        HomePage.id: (context) => _routeBranch(
              context,
              HomePage.id,
              HomePage(),
            ),
        ScanPage.id: (context) => _routeBranch(
              context,
              ScanPage.id,
              ScanPage(),
            ),
      },
    );
  }
}

Widget _routeBranch(BuildContext context, String id, Widget trueWidget) {
  final currentUser = FirebaseAuth.instance.currentUser;
  return (currentUser == null) ? SigninPage(id) : trueWidget;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('エラー'));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Haniwa();
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
