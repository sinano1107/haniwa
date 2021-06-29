import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/google_signin_button.dart';

class SigninPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _theme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: _height * 0.2),
            Center(
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 250,
              ),
            ),
            SizedBox(height: _height * 0.12),
            RichText(
              text: TextSpan(
                text: 'ようこそ',
                style: TextStyle(
                  fontSize: 30,
                ),
                children: [
                  TextSpan(
                    text: 'Haniwa',
                    style: TextStyle(
                      color: _theme.accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                  TextSpan(text: 'へ!'),
                ],
              ),
            ),
            SizedBox(height: _height * 0.05),
            GoogleSigninButton(),
          ],
        ),
      ),
    );
  }
}
