import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/pages/signin_page/index.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        child: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Container(),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('ログアウト'),
                onTap: () async {
                  try {
                    showProgressDialog(context);
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, SigninPage.id);
                  } catch (e) {
                    Navigator.pop(context);
                    print(e);
                    showSnackBar(context, 'サインアウトに失敗しました');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
