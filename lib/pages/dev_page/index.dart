import 'package:flutter/material.dart';
import 'package:haniwa/common/cloudstorage.dart';

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
          child: Text('画像アップロード'),
          onPressed: addMyImage,
        ),
      ),
    );
  }
}
