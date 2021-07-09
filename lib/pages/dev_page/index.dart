import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/providers/cloud_storage_provider.dart';
import 'package:haniwa/components/cloud_storage_image.dart';

class DevPage extends StatefulWidget {
  static const id = 'dev';

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  @override
  Widget build(BuildContext context) {
    List<String> _list = [
      'icon.png',
      'icon.png',
      'users/ifRbBduuNZtcW2hHpPrEdApbk3Gx/icon.JPG',
    ];

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CloudStorageProvider()),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: _list
                .map((String e) => CloudStorageImage(key: UniqueKey(), path: e))
                .toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            setState(() {
              _list.add('users/ifRbBduuNZtcW2hHpPrEdApbk3Gx/icon.JPG');
              print(_list);
            })
          },
        ),
      ),
    );
  }
}
