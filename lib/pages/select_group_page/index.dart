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
import 'package:haniwa/components/icon_button.dart';

class SelectGroupPage extends StatelessWidget {
  const SelectGroupPage({Key key}) : super(key: key);
  static const id = 'select-group';

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: _height * 0.7,
            child: QRViewWidget(),
          ),
          Text(
            '↑QRコードで参加↑',
            style: TextStyle(
              fontSize: 30,
              color: Colors.green,
            ),
          ),
          Text(
            'または',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: _height * 0.01),
          IconButtonWidget(
            color: Colors.blue,
            icon: Icon(Icons.group),
            text: 'グループを新規作成',
            onPressed: () => createNewGroup(context),
          ),
          SizedBox(height: _height * 0.01),
          MaterialButton(
            child: Text('サインアウト'),
            color: Colors.grey[300],
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
      final groupRef = await FirebaseFirestore.instance
          .collection('versions/v2/groups')
          .add({'admin': FirebaseAuth.instance.currentUser.uid});
      final groupId = groupRef.id;
      await addMe(uid, groupId);
      // グループIDをプロバイダに保存して遷移
      final userProvider = Provider.of<UserProvider>(
        context,
        listen: false,
      );
      userProvider.setUser(user_model.User(groupId: groupId));
      showSnackBar(context, 'グループの作成に成功しました');
      Navigator.pushReplacementNamed(context, ListPage.id);
    } catch (e) {
      print('グループ新規作成エラー $e');
      showSnackBar(context, 'グループの作成に失敗しました');
    }
  }
}
