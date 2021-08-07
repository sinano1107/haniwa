import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model.dart';
import 'content.dart';

class DeadlineGamblingCreatePage extends StatelessWidget {
  static const id = 'deadline_gambling_create';
  const DeadlineGamblingCreatePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DeadlineGamblingCreateViewModel(),
        ),
      ],
      child: DeadlineGamblingCreateContent(),
    );
  }
}
