import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model.dart';
import 'components/name_input_page.dart';
import 'components/deadline_input_page.dart';
import 'components/bet_input_page.dart';
import 'components/decision_page.dart';

class DeadlineGamblingCreateContent extends StatelessWidget {
  const DeadlineGamblingCreateContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _viewModel = Provider.of<DeadlineGamblingCreateViewModel>(context);

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
                  DeadlineInputPage(),
                  BetInputPage(),
                  DecisionPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
