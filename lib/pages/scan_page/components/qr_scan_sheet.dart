import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/extraction_group_tag_id.dart';

class QRScanSheet extends StatefulWidget {
  @override
  _QRScanSheetState createState() => _QRScanSheetState();
}

class _QRScanSheetState extends State<QRScanSheet> with ReassembleHandler {
  QRViewController _qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrController?.pauseCamera();
    }
    _qrController?.resumeCamera();
  }

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Container(
        height: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildQRView(context),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: TextButton(
                  child: Text(
                    'キャンセル',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: Size(300, 50),
                    primary: Colors.black,
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRView(BuildContext context) {
    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).primaryColor,
        borderRadius: 16,
        borderLength: 24,
        borderWidth: 8,
        overlayColor: Color.fromRGBO(0, 0, 0, 100),
      ),
    );
  }

  void _onQRViewCreated(QRViewController qrController) {
    setState(() => _qrController = qrController);
    // QR読み込みをlistenする
    qrController.scannedDataStream.listen((scanData) {
      // QRのデータが取得できない場合SnackBar表示
      if (scanData.code == null) showSnackBar(context, 'QRのデータを取得できませんでした');
      // 次の画面へ遷移
      _transitionToNextScreen(scanData.code);
    });
  }

  Future<void> _transitionToNextScreen(String uri) async {
    _qrController?.pauseCamera();
    final groupTagId = extractionGroupTagId(uri);
    print(groupTagId);
  }
}
