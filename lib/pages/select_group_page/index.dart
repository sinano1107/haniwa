import 'package:flutter/material.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/qr_view_widget.dart';
import 'package:haniwa/common/auth.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/providers/user_provider.dart';
import 'package:haniwa/models/user.dart' as user_model;
import 'package:haniwa/pages/list_page/index.dart';

class SelectGroupPage extends StatelessWidget {
  const SelectGroupPage({Key key}) : super(key: key);
  static const id = 'select-group';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: QRViewWidget()),
          MaterialButton(
            child: Text('新規作成'),
            onPressed: () => createNewGroup(context),
          ),
          MaterialButton(
            child: Text('サインアウト'),
            onPressed: () => signOut(context),
          ),
        ],
      ),
    );
  }

  void createNewGroup(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    try {
      // グループを新規作成して、グループ参加と同じ処理をする
      final groupRef =
          await FirebaseFirestore.instance.collection('groups').add({});
      final groupId = groupRef.id;
      addMe(uid, groupId);
      // グループIDをプロバイダに保存して遷移
      final userProvider = Provider.of<UserProvider>(
        context,
        listen: false,
      );
      userProvider.setUser(user_model.User(groupId: groupId));
      Navigator.pushReplacementNamed(context, ListPage.id);
    } catch (e) {
      print('グループ新規作成エラー $e');
      showSnackBar(context, 'グループの作成に失敗しました');
    }
  }
}
