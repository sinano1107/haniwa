import 'package:flutter/material.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

import 'pages/scan_page/scan_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      initialRoute: ScanPage.id,
      routes: {
        ScanPage.id: (_) => ScanPage(),
      },
    );
  }
}
