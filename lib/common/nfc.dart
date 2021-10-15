import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

// TODO: ここリリース時には本番用に置き換えないとダメよ
const head =
    'https://haniwa.page.link/?ibi=com.sinano1107.haniwa&isi=962194608&apn=com.example.haniwa&link=https%3A%2F%2Fqiita.com%2F%3Fid%3D';

void getTagId({
  @required nfcStop(String text),
  @required BuildContext context,
  @required String groupId,
  @required String questId,
}) async {
  if (!(await NfcManager.instance.isAvailable()))
    throw StateError('NFCタグを読み取れません');

  NfcManager.instance.startSession(
    onDiscovered: (NfcTag tag) async {
      // タグが読み取れない場合
      final ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        nfcStop('このタグとはリンクできません');
        return;
      }
      // URIを定義
      final uri = head + groupId + '-' + questId;
      final records = NdefMessage([NdefRecord.createUri(Uri.parse(uri))]);
      // 書き込み
      try {
        await ndef.write(records);
        nfcStop('タグへの書き込みに成功しました');
      } catch (_) {
        nfcStop('😭タグへの書き込みに失敗しました');
      }
    },
    onError: (_) async {
      const m = '書き込みに失敗しました';
      nfcStop(m);
      throw StateError(m);
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
