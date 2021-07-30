import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DevPage extends StatefulWidget {
  static const id = 'dev';

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DownloadImage(),
          DownloadImage(),
          DownloadImage(),
          MaterialButton(
            child: Text('アップロード'),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              final response = await http.get(Uri.parse(user.photoURL));
              final documentDirectory =
                  await getApplicationDocumentsDirectory();
              final file = File(join(documentDirectory.path, '1.png'));
              file.writeAsBytesSync(response.bodyBytes);
              print(file.uri);
              final metaData = SettableMetadata(
                cacheControl: 'max-age=600',
              );
              await FirebaseStorage.instance
                  .ref('dev/1.png')
                  .putFile(file, metaData);
            },
          ),
        ],
      ),
    );
  }
}

class DownloadImage extends StatelessWidget {
  const DownloadImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseStorage.instance.ref('dev/1.png').getDownloadURL(),
      builder: (context, ss) {
        if (ss.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        }
        if (ss.hasError) {
          return Text('エラー');
        }
        return Image.network(ss.data);
      },
    );
  }
}
