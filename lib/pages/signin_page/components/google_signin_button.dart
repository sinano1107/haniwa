import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:haniwa/common/snackbar.dart';
import '../signin_view_model.dart';

class GoogleSigninButton extends StatefulWidget {
  @override
  _GoogleSigninButtonState createState() => _GoogleSigninButtonState();
}

class _GoogleSigninButtonState extends State<GoogleSigninButton> {
  @override
  void initState() {
    final viewModel = Provider.of<SigninViewModel>(context, listen: false);
    viewModel.googleSigninAction.stream.listen((event) {
      if (event.isSucceed) {
        print('成功しました');
      } else {
        showSnackBar(context, 'Googleサインインに失敗しました');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      buttonType: (Theme.of(context).brightness == Brightness.dark)
          ? ButtonType.googleDark
          : ButtonType.google,
      buttonSize: ButtonSize.large,
      onPressed: Provider.of<SigninViewModel>(context, listen: false)
          .startGoogleSignin,
    );
  }
}
