import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/auth.dart';
import 'package:haniwa/models/member.dart';
import 'package:haniwa/components/cloud_storage_avatar.dart';
import 'package:haniwa/pages/group_qr_page.dart/index.dart';
import 'package:haniwa/pages/history_page/index.dart';
import 'package:haniwa/pages/members_page/index.dart';
import 'package:haniwa/pages/user_page/index.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final _user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        child: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.cyan),
                accountName: Text(_user.displayName),
                accountEmail: FutureBuilder<Member>(
                  future: MemberFirestore(context).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return CircularProgressIndicator();
                    }
                    if (!snapshot.hasError && snapshot.hasData) {
                      return Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: width * 0.08,
                          ),
                          SizedBox(width: width * 0.01),
                          Text(
                            '${snapshot.data.star.toString()}',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.1,
                            ),
                          ),
                        ],
                      );
                    }
                    return Text('エラー');
                  },
                ),
                currentAccountPicture: CloudStorageAvatar(
                  path: 'versions/v2/users/${_user.uid}/icon.png',
                ),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('クエスト達成の履歴'),
                onTap: () => Navigator.pushNamed(context, HistoryPage.id),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('ユーザー情報'),
                onTap: () => Navigator.pushNamed(context, UserPage.id),
              ),
              ListTile(
                leading: Icon(Icons.qr_code),
                title: Text('グループのQRコードを表示する'),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => GroupQrPage(),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.groups),
                title: Text('グループメンバー'),
                onTap: () => Navigator.pushNamed(context, MembersPage.id),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('ログアウト'),
                onTap: () => signOut(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
