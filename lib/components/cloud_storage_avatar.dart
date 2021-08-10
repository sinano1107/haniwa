import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageAvatar extends StatelessWidget {
  const CloudStorageAvatar({
    Key key,
    @required this.path,
    this.radius,
  }) : super(key: key);
  final String path;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return FutureBuilder(
      future: FirebaseStorage.instance.ref(path).getDownloadURL(),
      builder: (context, ss) {
        if (ss.connectionState != ConnectionState.done) {
          return CircleAvatar(
            child: CircularProgressIndicator(),
            backgroundColor: _theme.canvasColor,
            radius: radius,
          );
        }
        if (!ss.hasError && ss.hasData) {
          return CircleAvatar(
            backgroundImage: NetworkImage(ss.data),
            backgroundColor: _theme.canvasColor,
            radius: radius,
          );
        }
        print('エラーだお ${ss.error}');
        return CircleAvatar(
          child: Image.asset(
            'assets/images/error_haniwa.png',
            width: 25,
          ),
          backgroundColor: Colors.red,
          radius: radius,
        );
      },
    );
  }
}
