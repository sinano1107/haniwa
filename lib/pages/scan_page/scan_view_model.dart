import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:haniwa/common/nfc_session.dart';
import 'package:haniwa/common/extraction_url.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ScanViewModel extends ChangeNotifier {
  final _nfcSucceedAction = StreamController<NfcSucceedActionEvent>();
  StreamController<NfcSucceedActionEvent> get nfcAction => _nfcSucceedAction;

  // nfcスキャンをスタート
  void nfcScan() async {
    startSession(handleTag: _handleTag);
  }

  Future<String> _handleTag(NfcTag tag) async {
    final uri = extractionUri(tag);
    _nfcSucceedAction.sink.add(NfcSucceedActionEvent(uri));
    return 'タグの読み込みに成功しました';
  }

  @override
  void dispose() {
    _nfcSucceedAction.close();
    super.dispose();
  }
}

class NfcSucceedActionEvent {
  final String uri;
  NfcSucceedActionEvent(this.uri);
}
