import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/nfc.dart';
import 'package:haniwa/components/cloud_storage_avatar.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/components/report_dialog.dart';
import 'package:haniwa/pages/list_page/index.dart';
import 'package:haniwa/pages/quest_edit_page/index.dart';

class ReportQuestItem extends StatelessWidget {
  const ReportQuestItem({
    Key key,
    @required this.quest,
  }) : super(key: key);
  final ReportQuest quest;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // 今日とlastの日付は同じなら今日はもうやったということ
    final today = DateTime.now();
    bool isDone = quest.last != null &&
        quest.last.difference(today).inDays == 0 &&
        quest.last.day == today.day;
    bool isWorkingDay = true;
    if (!isDone) {
      // 曜日(-1)がworkingDaysに含まれていなければ今日やる必要はないということ
      final today = DateTime.now().weekday - 1;
      isWorkingDay = quest.workingDays.contains(today);
    }

    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: [buildTagAction(context)],
      secondaryActions: [buildDeleteAction(context)],
      child: ListTile(
        leading: _leading(isDone, isWorkingDay, quest.uid),
        title: Text(
          quest.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDone || !isWorkingDay ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: _subTitle(isDone, isWorkingDay, quest),
        trailing: RatingBarIndicator(
          rating: quest.star.toDouble(),
          itemCount: quest.star,
          itemBuilder: (_, __) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemSize: width * 0.05,
          unratedColor: Colors.transparent,
        ),
        onTap: isDone || !isWorkingDay ? null : () => showReportDialog(context),
        onLongPress: () => showDialog(
          context: context,
          builder: (_) => QuestEditPage(quest: quest),
        ),
      ),
    );
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

Widget _leading(bool isDone, bool isWorkingDay, String uid) {
  if (isDone) {
    return Icon(
      Icons.task_alt,
      color: Colors.blue,
      size: 40,
    );
  } else if (!isWorkingDay) {
    return Icon(
      Icons.coffee,
      color: Colors.brown,
      size: 40,
    );
  }
  return CloudStorageAvatar(path: 'versions/v2/users/$uid/icon.png');
}

Widget _subTitle(bool isDone, bool isWorkingDay, ReportQuest quest) {
  if (isDone) {
    return Text(
      '今日はクリア済み！すごい！！',
      style: TextStyle(color: Colors.blue),
    );
  } else if (!isWorkingDay) {
    // 次の勤務日までの日数を計算
    final today = DateTime.now().weekday - 1;
    final nextDay = quest.workingDays.firstWhere(
      (day) => today < day,
      orElse: () => quest.workingDays[0] + 7,
    );
    return Text(
      '今日は休み！次は${nextDay - today}日後',
      style: TextStyle(
        color: Colors.brown,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  return null;
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
