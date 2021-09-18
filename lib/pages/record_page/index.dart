import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/models/record.dart';
import 'view_model.dart';
import 'content.dart';

class RecordPage extends StatelessWidget {
  static const id = 'record';
  const RecordPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecordViewModel()),
      ],
      child: RecordContent(),
    );
  }
}

class RecordPageArguments {
  RecordPageArguments({
    @required this.record,
    @required this.name,
  });
  final Record record;
  final String name;
}
