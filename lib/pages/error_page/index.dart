import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  static const id = 'error';
  const ErrorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('エラー'),
      ),
    );
  }
}
