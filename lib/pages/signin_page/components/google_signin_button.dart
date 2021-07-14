import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_button/sign_button.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/cloudstorage.dart';
import 'package:haniwa/pages/list_page/index.dart';

class GoogleSigninButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      buttonType: ButtonType.google,
      buttonSize: ButtonSize.large,
      onPressed: () => startGoogleSignin(context),
    );
  }

  Future<void> startGoogleSignin(BuildContext context) async {
    showProgressDialog(context);
    try {
      final userCredential = await signInWithGoogle();
      if (userCredential.additionalUserInfo.isNewUser) {
        // 新しいユーザーだった場合
        await addMe(userCredential.user.uid);
        await addMyImage();
      }
      Navigator.pushReplacementNamed(context, ListPage.id);
      showSnackBar(context, 'サインインに成功しました！');
    } catch (e) {
      showSnackBar(context, 'サインインに失敗しました');
      print('サインインエラー: $e');
      Navigator.pop(context);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
