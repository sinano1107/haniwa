import 'package:flutter/material.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/models/member.dart';
import './content.dart';

class MembersPage extends StatelessWidget {
  static const id = 'members';
  const MembersPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<Member>> fetchMembers(BuildContext context) async {
      final data = await MembersColFirestore(context).get();
      return data;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('グループメンバー'),
      ),
      body: FutureBuilder<List<Member>>(
        future: fetchMembers(context),
        builder: (context, ss) {
          if (ss.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!ss.hasError) {
            return MembersPageContent(members: ss.data);
          }
          print('メンバー取得エラー: ${ss.error}');
          return Center(child: Text('エラー'));
        },
      ),
    );
  }
}
