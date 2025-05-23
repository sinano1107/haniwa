import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model.dart';
import 'components/branch.dart';
import 'components/name_input.dart';
import 'components/level_input.dart';
import 'components/select_day.dart';
import 'components/urgent_level_input.dart';

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
        child: Stack(
          fit: StackFit.loose,
          children: [
            PageView(
              controller: viewModel.controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Branch(),
                // ==通常クエスト==
                NameInput(),
                LevelInput(),
                SelectDay(),
                // ==緊急クエスト==
                NameInput(),
                UrgentLevelInput(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
