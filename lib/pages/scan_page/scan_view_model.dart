import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:haniwa/common/nfc_session.dart';
import 'package:haniwa/common/extraction_url.dart';
import 'package:haniwa/common/extraction_group_tag_id.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ScanViewModel extends ChangeNotifier {
  final _nfcSucceedAction = StreamController<NfcSucceedEvent>();
  StreamController<NfcSucceedEvent> get nfcAction => _nfcSucceedAction;

  final _showPermissionDialogAction =
      StreamController<ShowPermissionDialogEvent>();
  StreamController<ShowPermissionDialogEvent> get showPermissionDialogAction =>
      _showPermissionDialogAction;

  final _showQRScanSheetAction = StreamController<ShowQRScanSheetEvent>();
  StreamController<ShowQRScanSheetEvent> get showQRScanSheetAction =>
      _showQRScanSheetAction;

  // nfcスキャンをスタート
  void nfcScan() async {
    startSession(handleTag: (NfcTag tag) async {
      final uri = extractionUri(tag);
      final groupTagId = extractionGroupTagId(uri);
      _nfcSucceedAction.sink.add(NfcSucceedEvent(groupTagId));
      return 'タグの読み込みに成功しました';
    });
  }

  // qrスキャンをスタート
  void qrScan() async {
    if (await Permission.camera.request().isGranted) {
      _showQRScanSheetAction.sink.add(ShowQRScanSheetEvent());
    } else {
      _showPermissionDialogAction.sink.add(ShowPermissionDialogEvent());
    }
  }

  @override
  void dispose() {
    _nfcSucceedAction.close();
    _showPermissionDialogAction.close();
    _showQRScanSheetAction.close();
    super.dispose();
  }
}

class NfcSucceedEvent {
  final String groupTagId;
  NfcSucceedEvent(this.groupTagId);
}

class ShowPermissionDialogEvent {}

class ShowQRScanSheetEvent {}
