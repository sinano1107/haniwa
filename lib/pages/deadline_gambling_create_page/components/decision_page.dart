import 'package:flutter/material.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/notification.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../view_model.dart';
import 'package:haniwa/components/icon_button.dart';
import 'package:haniwa/pages/dev_page/index.dart';

class DecisionPage extends StatelessWidget {
  const DecisionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final formatter = DateFormat('M/d(E) HH:mm', 'ja_JP');
    final _viewModel = Provider.of<DeadlineGamblingCreateViewModel>(context);

    void create() async {
      showProgressDialog(context);
      try {
        int deadlineNoticeId;
        int soonNoticeId;
        // デッドラインの時間が過ぎていない場合
        // デッドラインの通知を設定する
        if (_viewModel.deadline.isAfter(DateTime.now())) {
          deadlineNoticeId = scheduleLocalNotification(
            _viewModel.deadline,
            '${_viewModel.name} のデッドラインとなりました',
            '結果報告は1時間後まで受け付けます！\nそれまでに報告しない場合失敗となります😇',
          );
        } else {
          // 過ぎていたらブレーク
          showSnackBar(context, 'すでにデッドラインが過ぎています');
          Navigator.pop(context);
          return;
        }
        // もうすぐの時間も過ぎていない場合
        // もうすぐの通知を設定する
        final soonDate = _viewModel.deadline.subtract(Duration(hours: 1));
        if (soonDate.isAfter(DateTime.now())) {
          soonNoticeId = scheduleLocalNotification(
            soonDate,
            '${_viewModel.name} のデッドラインが迫ってきました',
            '失敗すると${_viewModel.betPoint}pt失ってしまいます💦',
          );
        }
        await _viewModel.createDeadlineGambling(deadlineNoticeId, soonNoticeId);
        Navigator.popUntil(context, ModalRoute.withName(DevPage.id));
      } catch (e) {
        print('デッドラインギャンブル作成エラー: $e');
        showSnackBar(context, 'ギャンブルの保存に失敗しました');
        Navigator.pop(context);
      }
    }

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_viewModel.name),
            Text('を'),
            Text('${formatter.format(_viewModel.deadline)}'),
            Text('までに成功させる事に'),
            Text('${_viewModel.betPoint}pt賭けます！'),
            IconButtonWidget(
              color: _theme.primaryColor,
              icon: Icon(Icons.check),
              text: 'OK！',
              onPressed: create,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: IconButtonWidget(
            text: 'ベットポイント「${_viewModel.betPoint}pt」を編集する',
            color: Colors.grey[400],
            icon: Icon(Icons.arrow_back),
            onPressed: _viewModel.previousPage,
            size: Size(0, 40),
          ),
        ),
      ],
    );
  }
}
