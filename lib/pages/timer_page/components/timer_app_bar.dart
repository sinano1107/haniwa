import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model.dart';

class TimerAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<TimerViewModel>(context, listen: false);
    final _quest = _viewModel.quest;
    final _theme = Theme.of(context);

    return AppBar(
      title: Text(
        _quest.name,
        style: TextStyle(
          color: _theme.textTheme.bodyText1.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: _theme.iconTheme.color),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    );
  }
}
