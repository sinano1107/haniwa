import 'package:flutter/material.dart';
import 'components/list_app_bar.dart';

class DeadlineGamblingListPage extends StatelessWidget {
  static const id = 'deadline_gambling_list_page';
  const DeadlineGamblingListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ListAppBar(),
        ],
      ),
    );
  }
}
