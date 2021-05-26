import 'dart:convert';
import 'package:nfc_manager/nfc_manager.dart';

// nfcのレコードからurlを検索
String extractionUri(NfcTag tag) {
  final ndef = Ndef.from(tag);
  final uriRecord = ndef.cachedMessage.records.firstWhere(
    (record) => (record.type.length == 1) && (record.type.first == 0x55),
    orElse: () => throw StateError('情報が見つかりませんでした'),
  );
  final uri = utf8.decode(uriRecord.payload.sublist(1));
  return uri;
}
