import 'package:flutter/material.dart';
import 'components/qr_view_widget.dart';
import 'package:haniwa/common/auth.dart';

class SelectGroupPage extends StatelessWidget {
  const SelectGroupPage({Key key}) : super(key: key);
  static const id = 'select-group';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: QRViewWidget()),
          MaterialButton(
            child: Text('サインアウト'),
            onPressed: () => signOut(context),
          ),
        ],
      ),
    );
  }
}
