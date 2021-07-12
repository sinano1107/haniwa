import 'dart:convert';
import 'package:nfc_manager/nfc_manager.dart';

void getTagId(handle(String tagId)) async {
  if (!(await NfcManager.instance.isAvailable()))
    throw StateError('NFCタグを読み取れません');

  NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    NfcManager.instance.stopSession();
    final ndef = Ndef.from(tag);
    final uriRecord = ndef.cachedMessage.records.first;
    final uri = Uri.parse(utf8.decode(uriRecord.payload.sublist(1)));
    final linkUri = Uri.parse(uri.queryParameters['link']);
    handle(linkUri.queryParameters['id']);
  });
}
