import 'package:flutter/material.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/models/badge.dart';
import 'content.dart';

class UserPage extends StatelessWidget {
  static const id = 'user';
  const UserPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InputData>(
      future: fetchData(context),
      builder: (context, ss) {
        if (ss.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (ss.hasError) {
          print('データ取得エラー: ${ss.error}');
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('エラーが発生しました'),
            ),
          );
        }
        return UserPageContent(inputData: ss.data);
      },
    );
  }

  Future<InputData> fetchData(BuildContext context) async {
    final badgeData = await BadgesColFirestore(context).get();
    final badgeCount = (await MemberFirestore(context).get()).badgeCount;
    return InputData(badgeData, badgeCount);
  }
}

class InputData {
  InputData(this.badgeData, this.badgeCount);
  final List<BadgeData> badgeData;
  final Map<String, dynamic> badgeCount;
}
