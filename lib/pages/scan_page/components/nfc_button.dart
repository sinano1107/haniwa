import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/theme/common_theme.dart';
import 'package:haniwa/components/icon_button.dart';
import '../scan_view_model.dart';

class NfcButton extends StatefulWidget {
  @override
  _NfcButtonState createState() => _NfcButtonState();
}

class _NfcButtonState extends State<NfcButton> {
  @override
  void initState() {
    final viewModel = Provider.of<ScanViewModel>(context, listen: false);
    viewModel.nfcAction.stream.listen((event) {
      print(event.uri);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButtonWidget(
      icon: Icon(Icons.nfc),
      //text: 'タッチで読み込む',
      text: 'タッチで読み込む',
      color: kColor1,
      onPressed: Provider.of<ScanViewModel>(context, listen: false).nfcScan,
    );
  }
}
