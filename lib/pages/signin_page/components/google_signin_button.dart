import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_button/sign_button.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import '../view_model.dart';

class GoogleSigninButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      buttonType: (Theme.of(context).brightness == Brightness.dark)
          ? ButtonType.googleDark
          : ButtonType.google,
      buttonSize: ButtonSize.large,
      onPressed: () => startGoogleSignin(context),
    );
  }

  Future<void> startGoogleSignin(BuildContext context) async {
    showProgressDialog(context);
    try {
      await signInWithGoogle();
      final _viewModel = Provider.of<SigninViewModel>(context, listen: false);
      Navigator.pushReplacementNamed(context, _viewModel.nextPageId);
      showSnackBar(context, 'サインインに成功しました！');
    } catch (e) {
      showSnackBar(context, 'サインインに失敗しました');
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
