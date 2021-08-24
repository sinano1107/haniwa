import 'package:flutter/material.dart';

class DevPage extends StatefulWidget {
  static const id = 'dev';

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          child: Text('クエスト追加'),
          onPressed: () => {},
        ),
      ),
    );
  }
}
