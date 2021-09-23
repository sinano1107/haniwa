import 'package:flutter/material.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/models/badge.dart';
import 'content.dart';

class UserPage extends StatelessWidget {
  static const id = 'user';
  const UserPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BadgeData>>(
      future: BadgesColFirestore(context).get(),
      builder: (context, ss) {
        if (ss.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (ss.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('エラーが発生しました'),
            ),
          );
        }
        return UserPageContent(badgeData: ss.data);
      },
    );
  }
}
