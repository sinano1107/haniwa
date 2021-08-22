import 'package:flutter/material.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/pages/list_page/index.dart';

class FinishButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return ElevatedButton(
      child: Text(
        'おつかれさま！🎉',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(300, 60),
        primary: _theme.primaryColor,
        shape: StadiumBorder(),
      ),
      onPressed: () {
        showSnackBar(context, 'あんなことよくできたね！すごいよ！！ありがとう😊');
        Navigator.popUntil(
          context,
          ModalRoute.withName(ListPage.id),
        );
      },
    );
  }
}
