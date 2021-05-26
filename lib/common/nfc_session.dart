import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

Future<void> startSession({
  @required Future<String> Function(NfcTag) handleTag,
  String alertMessage = 'タグとスマホを近づけてください',
}) async {
  if (Platform.isIOS) {
    // iOSの処理
    return NfcManager.instance.startSession(
      alertMessage: alertMessage,
      onDiscovered: (tag) async {
        try {
          final result = await handleTag(tag);
          if (result == null) return;
          await NfcManager.instance.stopSession(alertMessage: result);
        } catch (e) {
          await NfcManager.instance.stopSession(errorMessage: '$e');
        }
      },
    );
  }

  const androidMessage = 'Android用のnfc_read処理は実装されていません';
  print(androidMessage);
  return AlertDialog(title: Text(androidMessage));
}
