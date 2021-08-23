import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/nfc.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/components/report_dialog.dart';
import 'package:haniwa/theme/colors.dart';

class ReportQuestItem extends StatelessWidget {
  const ReportQuestItem({
    Key key,
    @required this.quest,
  }) : super(key: key);
  final ReportQuest quest;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: [buildTagAction(context)],
      child: ListTile(
        leading: Icon(
          Icons.local_fire_department,
          color: Colors.orange[brightness],
          size: 40,
        ),
        title: Text(
          quest.name,
        ),
        trailing: Text(
          '${quest.point}pt',
          style: TextStyle(
            color: kPointColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => showReportDialog(context),
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
              await updateTagQuest(context, tagId.split('-').last, quest);
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
}
