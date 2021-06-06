import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:haniwa/common/progress.dart';
import '../signin_view_model.dart';

class GoogleSigninButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      buttonType: (Theme.of(context).brightness == Brightness.dark)
          ? ButtonType.googleDark
          : ButtonType.google,
      buttonSize: ButtonSize.large,
      onPressed: () {
        showProgressDialog(context);
        Provider.of<SigninViewModel>(context, listen: false)
            .startGoogleSignin();
      },
    );
  }
}
