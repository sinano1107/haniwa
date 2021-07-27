import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/auth.dart';
import 'package:haniwa/theme/colors.dart';
import 'package:haniwa/models/member.dart';
import 'package:haniwa/components/cloud_storage_avatar.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                accountName: Text('${_user.displayName} の所持ポイント'),
                accountEmail: FutureBuilder<Member>(
                  future: fetchMemberData(_user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return CircularProgressIndicator();
                    }
                    if (!snapshot.hasError && snapshot.hasData) {
                      return Text(
                        '${snapshot.data.point.toString()}pt',
                        style: TextStyle(
                          color: kPointColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      );
                    }
                    return Text('エラー');
                  },
                ),
                currentAccountPicture: CloudStorageAvatar(
                  path: 'users/${_user.uid}/icon.JPG',
                ),
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
