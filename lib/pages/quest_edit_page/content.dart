import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:haniwa/models/report_quest.dart';
import 'package:haniwa/components/icon_button.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:haniwa/common/firestore.dart';
import 'package:haniwa/pages/list_page/index.dart';
import 'view_model.dart';

const daysOfWeek = [
  '月',
  '火',
  '水',
  '木',
  '金',
  '土',
  '日',
];

class QuestEditContent extends StatefulWidget {
  const QuestEditContent({
    Key key,
    @required this.quest,
  }) : super(key: key);
  final ReportQuest quest;

  @override
  _QuestEditContentState createState() => _QuestEditContentState();
}

class _QuestEditContentState extends State<QuestEditContent> {
  @override
  void initState() {
    final viewModel = Provider.of<QuestEditViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.editWorkingDays(widget.quest.workingDays);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestEditViewModel>(context, listen: false);
    final listenViewModel = Provider.of<QuestEditViewModel>(context);
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final quest = widget.quest;

    return AlertDialog(
      title: Text('クエストを編集する'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: quest.name,
            onChanged: viewModel.editName,
            maxLength: 20,
          ),
          RatingBar.builder(
            itemBuilder: (_, __) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            minRating: 1,
            initialRating: quest.star.toDouble(),
            itemCount: 3,
            onRatingUpdate: viewModel.editStar,
          ),
          SizedBox(height: height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              daysOfWeek.length,
              (index) => DayButton(index: index),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Checkbox(
                value: listenViewModel.workingDays.length == 7,
                onChanged: (value) {
                  if (value) {
                    viewModel.editWorkingDays([0, 1, 2, 3, 4, 5, 6]);
                  } else {
                    viewModel.editWorkingDays([]);
                  }
                },
              ),
              Text('毎日'),
            ],
          ),
          IconButtonWidget(
            icon: Icon(Icons.edit),
            text: '編集する',
            color: theme.primaryColor,
            size: Size(200, 40),
            onPressed: () async {
              final name = viewModel.name;
              final star = viewModel.star;
              final workingDays = viewModel.workingDays;
              if (name.length == 0) {
                showSnackBar(context, '名前がありません');
                return;
              }
              if (workingDays.length == 0) {
                showSnackBar(context, '曜日が設定されていません');
                return;
              }
              showProgressDialog(context);
              try {
                await QuestFirestore(context, quest.id).update({
                  'name': name,
                  'star': star.toInt(),
                  'workingDays': workingDays,
                });
              } catch (e) {
                print('クエスト編集エラー $e');
                showSnackBar(context, '編集に失敗しました');
              }
              Navigator.popUntil(context, ModalRoute.withName(ListPage.id));
            },
          ),
        ],
      ),
    );
  }
}

class DayButton extends StatelessWidget {
  const DayButton({
    Key key,
    @required this.index,
  }) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestEditViewModel>(context, listen: false);
    final listenViewModel = Provider.of<QuestEditViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => viewModel.toggleWorkingDays(index),
      child: CircleAvatar(
        backgroundColor: listenViewModel.workingDays.contains(index)
            ? Colors.blue
            : Colors.grey,
        child: Text(
          daysOfWeek[index],
          style: TextStyle(
            fontSize: width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
        radius: width * 0.035,
      ),
    );
  }
}
