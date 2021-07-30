import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'progress.dart';
import 'snackbar.dart';
import 'package:haniwa/pages/signin_page/index.dart';

Future signOut(BuildContext context) async {
  try {
    showProgressDialog(context);
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, SigninPage.id);
  } catch (e) {
    print(e);
    Navigator.pop(context);
    showSnackBar(context, 'サインアウトに失敗しました');
  }
}
