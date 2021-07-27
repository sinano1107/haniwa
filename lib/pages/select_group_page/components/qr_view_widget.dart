import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/providers/user_provider.dart';
import 'package:haniwa/models/user.dart' as user_model;
import 'package:haniwa/pages/list_page/index.dart';

class QRViewWidget extends StatefulWidget {
  const QRViewWidget({Key key}) : super(key: key);

  @override
  _QRViewWidgetState createState() => _QRViewWidgetState();
}

class _QRViewWidgetState extends State<QRViewWidget> {
  QRViewController _qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isQRScanned = false;

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
      if (!_isQRScanned) {
        // カメラを一時停止
        _qrController.pauseCamera();
        _isQRScanned = true;
        print('aaaaaaa ${scanData.code}');
        join(context, scanData.code);
      }
    });
  }

  void join(BuildContext context, String groupId) async {
    final _uid = FirebaseAuth.instance.currentUser.uid;
    try {
      await addMe(_uid, groupId);
      await editUser(_uid, groupId);
      // グループIDをプロバイダに保存して遷移
      final userProvider = Provider.of<UserProvider>(
        context,
        listen: false,
      );
      userProvider.setUser(user_model.User(groupId: groupId));
      Navigator.pushReplacementNamed(context, ListPage.id);
    } catch (e) {
      print('グループ参加エラー $e');
      showSnackBar(context, 'groupの参加に失敗しました');
    }
  }
}
