import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/nfc.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/components/report_dialog.dart';
import 'package:haniwa/theme/colors.dart';
import 'package:haniwa/pages/list_page/index.dart';

class ReportQuestItem extends StatelessWidget {
  const ReportQuestItem({
    Key key,
    @required this.quest,
  }) : super(key: key);
  final ReportQuest quest;

  @override
  Widget build(BuildContext context) {
    // 今日とlastの日付は同じなら今日はもうやったということ
    final today = DateTime.now();
    bool isDone = quest.last != null &&
        quest.last.difference(today).inDays == 0 &&
        quest.last.day == today.day;

    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: [buildTagAction(context)],
      secondaryActions: [buildDeleteAction(context)],
      child: ListTile(
        leading: Icon(
          isDone ? Icons.task_alt : Icons.local_fire_department,
          color: isDone ? Colors.blue : Colors.orange[brightness],
          size: 40,
        ),
        title: Text(
          quest.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDone ? Colors.grey : Colors.black87,
          ),
        ),
        trailing: Text(
          '${quest.point}pt',
          style: TextStyle(
            color: isDone ? Colors.teal[100] : kPointColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: isDone
            ? Text(
                '今日はクリア済み！すごい！！',
                style: TextStyle(color: Colors.blue),
              )
            : null,
        onTap: isDone ? null : () => showReportDialog(context),
      ),
    );
  }

  int get brightness {
    final level = quest.level;
    if (level == 0.5) return 50;
    return ((level - 0.5) * 200).toInt();
  }

  void showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ReportDialog(quest: quest),
    );
  }

  IconSlideAction buildTagAction(BuildContext context) {
    return IconSlideAction(
      caption: 'タグにリンクする',
      color: Colors.lightGreen,
      foregroundColor: Colors.white,
      icon: Icons.nfc,
      onTap: () {
        getTagId(
          handle: (tagId) async {
            showProgressDialog(context);
            try {
              await TagFirestore(
                context,
                tagId.split('-').last,
              ).update(quest);
              showSnackBar(context, 'タグとのリンクに成功しました');
            } catch (e) {
              print('タグアップデートエラー: $e');
              showSnackBar(context, 'タグとのリンクに失敗しました');
            }
            Navigator.pop(context);
          },
          context: context,
        );
      },
    );
  }

  IconSlideAction buildDeleteAction(BuildContext context) {
    return IconSlideAction(
      caption: '削除',
      color: Colors.red,
      icon: Icons.delete,
      onTap: () => showDialog(
        context: context,
        builder: (context) => _deleteDialog(context, quest),
      ),
    );
  }
}

Widget _deleteDialog(BuildContext context, ReportQuest quest) {
  return AlertDialog(
    title: Text('${quest.name}を本当に削除しますか？'),
    content: Text(
      'この操作は取り消せません。本当によろしいですか？',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      TextButton(
        child: Text(
          'キャンセル',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      TextButton(
        child: Text(
          '削除する',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        onPressed: () => deleteQuestAction(context, quest),
      ),
    ],
  );
}

void deleteQuestAction(BuildContext context, ReportQuest quest) async {
  showProgressDialog(context);
  try {
    await QuestFirestore(context, quest.id).delete();
  } catch (e) {
    print('クエスト削除エラー $e');
    showSnackBar(context, 'クエストの削除に失敗しました');
  }
  Navigator.popUntil(context, ModalRoute.withName(ListPage.id));
}
