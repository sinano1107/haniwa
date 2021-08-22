import 'package:flutter/material.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/theme/colors.dart';
import 'package:haniwa/pages/result_page/index.dart';

class ReportQuestItem extends StatelessWidget {
  const ReportQuestItem({
    Key key,
    @required this.quest,
  }) : super(key: key);
  final ReportQuest quest;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }

  int get brightness {
    final lebel = quest.lebel;
    if (lebel == 0.5) return 50;
    return ((lebel - 0.5) * 200).toInt();
  }

  void showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ほうこくする'),
        content: Text('ま、まさか、、あの伝説の\n「${quest.name}」\nをこなしてきたのかい！？'),
        actions: [
          TextButton(
            child: Text('まだだ！'),
            onPressed: () {
              Navigator.pop(context);
              showSnackBar(context, 'まぁほどほどに頑張ろう！');
            },
          ),
          TextButton(
            child: Text(
              'できたよ！',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                ResultPage.id,
                arguments: ResultArguments(quest: quest),
              );
            },
          ),
        ],
      ),
    );
  }
}
