import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model.dart';
import 'components/name_input_page.dart';
import 'components/schedule_input_page.dart';
import 'components/bet_input_page.dart';

class QuestCreateContent extends StatelessWidget {
  const QuestCreateContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _viewModel = Provider.of<QuestCreateViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: _theme.iconTheme.color),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: PageView(
                controller: _viewModel.controller,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  NameInputPage(),
                  ScheduleInputPage(),
                  BetInputPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
