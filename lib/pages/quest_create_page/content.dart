import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model.dart';
import 'components/name_input.dart';
import 'components/lebel_input.dart';

class QuestCreateContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestCreateViewModel>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.iconTheme.color),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 35,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: PageView(
                controller: viewModel.controller,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  NameInput(),
                  LebelInput(),
                  Text('iiii'),
                  Text('uuuu'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
