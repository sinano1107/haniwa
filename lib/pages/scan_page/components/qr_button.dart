import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:haniwa/theme/common_theme.dart';
import 'package:haniwa/components/icon_button.dart';
import '../scan_view_model.dart';
import 'qr_scan_sheet.dart';

class QRButton extends StatefulWidget {
  @override
  _QRButtonState createState() => _QRButtonState();
}

class _QRButtonState extends State<QRButton> {
  @override
  void initState() {
    final viewModel = Provider.of<ScanViewModel>(context, listen: false);
    // カメラの権限を要求するダイアログ
    viewModel.showPermissionDialogAction.stream.listen((_) {
      showRequestPermissionDialog();
    });
    // QRコードを読み込むシート
    viewModel.showQRScanSheetAction.stream.listen((_) {
      showModalBottomSheet(
        context: context,
        builder: (_) => QRScanSheet(),
        backgroundColor: Colors.transparent,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButtonWidget(
      icon: Icon(Icons.qr_code),
      text: 'QRコードで読み込む',
      color: kColor2,
      onPressed: Provider.of<ScanViewModel>(context, listen: false).qrScan,
    );
  }

  Future<void> showRequestPermissionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('カメラを許可してください'),
          content: Text('QRコードを読み取るためにカメラを利用します'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.popUntil(
                context,
                (route) => route.isFirst,
              ),
              child: Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () async {
                openAppSettings();
              },
              child: Text('設定'),
            ),
          ],
        );
      },
    );
  }
}
