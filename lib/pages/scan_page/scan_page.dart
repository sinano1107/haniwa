import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haniwa/theme/common_theme.dart';
import 'package:haniwa/components/icon_button.dart';
import 'scan_view_model.dart';

class ScanPage extends StatefulWidget {
  static const id = 'scan';

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScanViewModel()),
      ],
      child: ScanPageContent(),
    );
  }
}

class ScanPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            SvgPicture.asset('assets/images/phone.svg'),
            SizedBox(height: 10),
            Text(
              '今後アプリを開く必要はありません',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('ホーム画面やカメラアプリからも反応します'),
            SizedBox(height: 50),
            IconButtonWidget(
              icon: Icon(Icons.nfc),
              text: 'タッチで読み込む',
              color: kColor1,
            ),
            SizedBox(height: 10),
            Text('or', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            IconButtonWidget(
              icon: Icon(Icons.qr_code),
              text: 'QRコードで読み込む',
              color: kColor2,
            ),
          ],
        ),
      ),
    );
  }
}
