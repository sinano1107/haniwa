import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/providers/haniwa_provider.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/models/member.dart';
import 'components/delete_dialog.dart';
import './content.dart';

class MembersPage extends StatelessWidget {
  static const id = 'members';
  const MembersPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HaniwaProvider>(context, listen: false);
    final isAdmin = provider.admin == FirebaseAuth.instance.currentUser.uid;

    Future<List<Member>> fetchMembers(BuildContext context) async {
      final data = await MembersColFirestore(context).get();
      return data;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('グループメンバー'),
        actions: [
          IconButton(
            icon: Icon(
              isAdmin ? Icons.delete_forever_outlined : Icons.logout_rounded,
              color: Colors.red[300],
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => DeleteDialog(
                isAdmin: isAdmin,
              ),
            ),
          )
        ],
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
