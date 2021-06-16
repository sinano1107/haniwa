import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'scan_view_model.dart';
import 'components/nfc_button.dart';
import 'components/qr_button.dart';
import 'package:haniwa/pages/tag_info_page/tag_info_page.dart';

class ScanPage extends StatelessWidget {
  static const id = 'scan';

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

class ScanPageContent extends StatefulWidget {
  @override
  _ScanPageContentState createState() => _ScanPageContentState();
}

class _ScanPageContentState extends State<ScanPageContent> {
  @override
  void initState() {
    final viewModel = Provider.of<ScanViewModel>(context, listen: false);
    viewModel.nfcAction.stream.listen((event) {
      print(event.groupTagId);
      Navigator.pushReplacementNamed(
        context,
        TagInfoPage.id,
        arguments: TagInfoArguments(
          groupTagId: event.groupTagId,
          elapsedTime: null,
          wasOngoing: null,
          endTime: null,
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyText1.color),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
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
            NfcButton(),
            SizedBox(height: 10),
            Text('or', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            QRButton(),
          ],
        ),
      ),
    );
  }
}
