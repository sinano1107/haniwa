import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void getTagId({handle(String tagId), BuildContext context}) async {
  if (!(await NfcManager.instance.isAvailable()))
    throw StateError('NFCタグを読み取れません');

  NfcManager.instance.startSession(
    onDiscovered: (NfcTag tag) async {
      final ndef = Ndef.from(tag);
      final uriRecord = ndef.cachedMessage.records.first;
      final uri = Uri.parse(utf8.decode(uriRecord.payload.sublist(1)));
      final linkUri = Uri.parse(uri.queryParameters['link']);
      if (Platform.isAndroid) Navigator.pop(context);
      handle(linkUri.queryParameters['id']);
      if (Platform.isAndroid) {
        // androidなら連続読み込みを防止するために5秒待ってからストップする
        await Future.delayed(Duration(seconds: 5));
      }
      NfcManager.instance.stopSession();
    },
    onError: (_) async {
      if (Platform.isAndroid) {
        Navigator.pop(context);
        await Future.delayed(Duration(seconds: 5));
      }
      NfcManager.instance.stopSession();
      throw StateError('NFCタグ読み込みに失敗しました');
    },
  );

  if (Platform.isAndroid) {
    // Androidの場合dialogを生成してNFCタグ読み込み可能だと伝える
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('NFCタグをスキャンしてください'),
          content: Icon(Icons.nfc),
          actions: [
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                NfcManager.instance.stopSession();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
