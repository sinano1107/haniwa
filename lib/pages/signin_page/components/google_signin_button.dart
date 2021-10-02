import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_button/sign_button.dart';
import 'package:haniwa/pages/select_group_page/index.dart';
import 'package:haniwa/pages/list_page/index.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/cloudstorage.dart';
import 'package:haniwa/providers/haniwa_provider.dart';

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
        await addMyImage();
        // groupIdをnullに設定してgroup所属画面へ
        await UserFirestore().initUser();
        Navigator.pushReplacementNamed(context, SelectGroupPage.id);
      } else {
        // groupId,権限者uidを取得・保存してlist画面へ
        final groupId = await UserFirestore().fetchMyGroupId();
        String admin;
        final haniwaProvider = Provider.of<HaniwaProvider>(
          context,
          listen: false,
        );
        if (groupId == null) {
          // ログインしたがgroupIdがnullだった場合
          haniwaProvider.init(groupId: groupId, admin: admin);
          Navigator.pushReplacementNamed(context, SelectGroupPage.id);
        } else {
          admin =
              (await GroupFirestore(context).get(groupId: groupId))['admin'];
          haniwaProvider.init(groupId: groupId, admin: admin);
          Navigator.pushReplacementNamed(context, ListPage.id);
        }
      }
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
