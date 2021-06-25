import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/pages/list_page/index.dart';
import '../view_model.dart';

class TimerAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<TimerViewModel>(context, listen: false);
    final _quest = _viewModel.quest;
    final _controller = _viewModel.controller;
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
      leading: BackButton(
        onPressed: () => _back(context, _controller),
      ),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    );
  }

  void _back(BuildContext context, CountDownController controller) {
    final time = controller.getTime();
    if (time != '00:00') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('作業のデータは削除されます'),
          content: Text('本当に戻りますか'),
          actions: [
            TextButton(
              child: Text(
                'キャンセル',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                '戻る',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.popUntil(
                context,
                ModalRoute.withName(ListPage.id),
              ),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.pop(context);
  }
}
