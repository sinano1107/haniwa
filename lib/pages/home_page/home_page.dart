import 'package:flutter/material.dart';
import 'package:haniwa/pages/scan_page/scan_page.dart';

class HomePage extends StatelessWidget {
  static const id = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ホーム')),
      body: Center(
        child: MaterialButton(
          child: Text('スキャン'),
          onPressed: () => Navigator.pushNamed(context, ScanPage.id),
        ),
      ),
    );
  }
}
