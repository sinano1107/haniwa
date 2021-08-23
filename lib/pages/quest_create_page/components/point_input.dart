import 'package:flutter/material.dart';
import 'package:haniwa/common/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:haniwa/components/icon_button.dart';
import 'package:haniwa/common/progress.dart';
import 'package:haniwa/pages/list_page/index.dart';
import '../view_model.dart';

class PointInput extends StatefulWidget {
  const PointInput({Key key}) : super(key: key);

  @override
  _PointInputState createState() => _PointInputState();
}

class _PointInputState extends State<PointInput> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestCreateViewModel>(context, listen: false);
    final listenViewModel = Provider.of<QuestCreateViewModel>(context);
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'ポイントはこれくらい？',
                style: TextStyle(
                  fontSize: width * 0.08,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: NumberPicker(
                value: listenViewModel.point,
                minValue: 50,
                maxValue: 500,
                step: 10,
                haptics: true,
                onChanged: viewModel.editPoint,
                itemHeight: 100,
                itemWidth: 300,
                textStyle: TextStyle(
                  fontSize: 25,
                ),
                selectedTextStyle: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),
                textMapper: (value) => value + 'pt',
              ),
            ),
            SizedBox(height: height * 0.05),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButtonWidget(
                text: '難易度\'${viewModel.level}\'を編集する',
                color: Colors.grey,
                icon: Icon(Icons.arrow_back),
                onPressed: viewModel.previousPage,
                size: Size(0, 40),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 150),
                child: IconButtonWidget(
                  icon: Icon(Icons.send),
                  text: 'クエストを追加する！',
                  color: theme.primaryColor,
                  size: Size(330, 50),
                  onPressed: () async {
                    showProgressDialog(context);
                    try {
                      print('iii');
                      await viewModel.createQuest(context);
                      print('aaa');
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(ListPage.id),
                      );
                    } catch (e) {
                      showSnackBar(context, 'クエスト追加に失敗しました');
                      print('クエスト追加エラー: $e');
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
