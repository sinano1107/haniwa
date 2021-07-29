import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:haniwa/providers/user_provider.dart';

class GroupQrPage extends StatelessWidget {
  const GroupQrPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Container(
      child: Center(
        child: QrImage(
          data: userProvider.user.groupId,
          size: 250,
        ),
      ),
    );
  }
}
