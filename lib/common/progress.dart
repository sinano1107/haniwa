import 'package:flutter/material.dart';

void showProgressDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext context, _, __) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
