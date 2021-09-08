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

class QuestEditContent extends StatelessWidget {
  const QuestEditContent({
    Key key,
    @required this.quest,
  }) : super(key: key);
  final ReportQuest quest;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestEditViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

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
          SizedBox(height: height * 0.01),
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
          SizedBox(height: height * 0.018),
          IconButtonWidget(
            icon: Icon(Icons.edit),
            text: '編集する',
            color: theme.primaryColor,
            size: Size(200, 40),
            onPressed: () async {
              final name = viewModel.name;
              final star = viewModel.star;
              if (name.length == 0) {
                showSnackBar(context, '名前がありません');
                return;
              }
              if (name == quest.name && star == quest.star.toDouble()) {
                showSnackBar(context, '変更がありません');
                return;
              }
              showProgressDialog(context);
              try {
                await QuestFirestore(context, quest.id).update({
                  'name': viewModel.name,
                  'star': viewModel.star.toInt(),
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
