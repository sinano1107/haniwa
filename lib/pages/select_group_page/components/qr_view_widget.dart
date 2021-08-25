import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/providers/haniwa_provider.dart';
import 'package:haniwa/pages/list_page/index.dart';

class QRViewWidget extends StatefulWidget {
  const QRViewWidget({Key key}) : super(key: key);

  @override
  _QRViewWidgetState createState() => _QRViewWidgetState();
}

class _QRViewWidgetState extends State<QRViewWidget> {
  QRViewController _qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isPause = false;

  // ホットリロードwp機能させるには、プラットフォームがAndroidの場合はカメラを一時停止するか、
  // プラットフォームがiOSの場合はカメラを再開する必要がある
  @override
  void reassemble() {
    if (Platform.isAndroid) {
      _qrController.pauseCamera();
    }
    _qrController.resumeCamera();
    super.reassemble();
  }

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 16,
        borderLength: 24,
        borderWidth: 8,
      ),
    );
  }

  void _onQRViewCreated(QRViewController qrController) {
    setState(() {
      _qrController = qrController;
    });
    // QRを読み込みをlistenする
    qrController.scannedDataStream.listen((scanData) {
      // QRのデータが取得できない場合SnackBar表示
      if (scanData.code == null) {
        showSnackBar(context, 'QRコード読み込みに失敗しました');
      }
      if (!_isPause) {
        // カメラを一時停止
        _qrController.pauseCamera();
        _isPause = true;
        showProgressDialog(context);
        join(context, scanData.code);
      }
    });
  }

  void join(BuildContext context, String groupId) async {
    final _uid = FirebaseAuth.instance.currentUser.uid;
    try {
      await GroupFirestore(context).addMe();
      // グループID,権限者uidをプロバイダに保存して遷移
      final admin = (await GroupFirestore(context).fetchGroupData())['admin'];
      final haniwaProvider = Provider.of<HaniwaProvider>(
        context,
        listen: false,
      );
      haniwaProvider.init(groupId: groupId, admin: admin);
      showSnackBar(context, 'グループへの参加に成功しました');
      Navigator.pushReplacementNamed(context, ListPage.id);
    } catch (e) {
      print('グループ参加エラー $e');
      _qrController.resumeCamera();
      _isPause = false;
      Navigator.pop(context);
      showSnackBar(context, 'グループの参加に失敗しました');
    }
  }
}
