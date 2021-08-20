import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/providers/haniwa_provider.dart';

String fetchGroupId(BuildContext context) {
  final haniwaProvider = Provider.of<HaniwaProvider>(context, listen: false);
  return haniwaProvider.groupId;
}
