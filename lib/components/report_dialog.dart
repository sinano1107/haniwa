import 'package:flutter/material.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/pages/result_page/index.dart';

class ReportDialog extends StatelessWidget {
  const ReportDialog({
    Key key,
    @required this.quest,
  }) : super(key: key);
  final ReportQuest quest;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            Navigator.pushReplacementNamed(
              context,
              ResultPage.id,
              arguments: ResultArguments(quest: quest),
            );
          },
        ),
      ],
    );
  }
}
