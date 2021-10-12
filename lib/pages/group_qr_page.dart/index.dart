import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:haniwa/providers/haniwa_provider.dart';

class GroupQrPage extends StatelessWidget {
  const GroupQrPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final haniwaProvider = Provider.of<HaniwaProvider>(context, listen: false);

    return Container(
      color: Colors.white,
      child: Center(
        child: QrImage(
          data: haniwaProvider.groupId,
          size: 250,
        ),
      ),
    );
  }
}
